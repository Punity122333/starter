-- lua/snippet_engine/init.lua
-- Custom snippet engine: parses LSP snippet syntax, manages sessions via
-- extmarks, mirrors linked tabstops, applies regex transforms on jump,
-- and shows choice node UI. Zero external dependencies.

local M = {}

local ns = vim.api.nvim_create_namespace("snip_engine")

-- Localise hot-path API calls (avoids table lookup overhead in TextChangedI)
local nvim_buf_get_extmark = vim.api.nvim_buf_get_extmark_by_id
local nvim_buf_get_lines   = vim.api.nvim_buf_get_lines
local nvim_buf_set_text    = vim.api.nvim_buf_set_text
local nvim_win_get_cursor  = vim.api.nvim_win_get_cursor
local nvim_win_set_cursor  = vim.api.nvim_win_set_cursor

-- ============================================================================
-- TRANSFORM HELPERS
-- ============================================================================

local modifiers = {
  upcase     = function(s) return s:upper() end,
  downcase   = function(s) return s:lower() end,
  capitalize = function(s)
    if s == "" then return s end
    return s:sub(1,1):upper() .. s:sub(2)
  end,
  camelcase  = function(s)
    local words, result = {}, nil
    for w in s:gmatch("[%w]+") do words[#words+1] = w end
    if #words == 0 then return s end
    result = words[1]:lower()
    for i = 2, #words do
      result = result .. words[i]:sub(1,1):upper() .. words[i]:sub(2):lower()
    end
    return result
  end,
  pascalcase = function(s)
    local result = ""
    for w in s:gmatch("[%w]+") do
      result = result .. w:sub(1,1):upper() .. w:sub(2):lower()
    end
    return result
  end,
}

-- Parse LSP transform format string into a list of segments:
--   {type="lit",     value=str}
--   {type="cap",     index=N, modifier=str|nil}
--   {type="if_set",  index=N, value=str}
--   {type="cond",    index=N, if_set=str, if_not=str}
--   {type="default", index=N, default=str}
local function parse_format(fmt)
  local segs = {}
  local i, len, text = 1, #fmt, ""

  local function flush()
    if text ~= "" then segs[#segs+1] = {type="lit", value=text}; text="" end
  end

  while i <= len do
    local ch = fmt:sub(i,i)

    if ch == "\\" and i < len then
      i = i+1; text = text .. fmt:sub(i,i); i = i+1

    elseif ch == "$" then
      flush(); i = i+1
      if fmt:sub(i,i) == "{" then
        i = i+1
        -- read index
        local s = i
        while i <= len and fmt:sub(i,i):match("%d") do i = i+1 end
        local idx = tonumber(fmt:sub(s, i-1)) or 0
        local nc  = fmt:sub(i,i)

        if nc == "}" then
          i = i+1
          segs[#segs+1] = {type="cap", index=idx}

        elseif nc == ":" then
          i = i+1
          local mc = fmt:sub(i,i)

          if mc == "/" then
            -- ${N:/modifier}
            i = i+1
            local ms = i
            while i <= len and fmt:sub(i,i) ~= "}" do i = i+1 end
            local mod = fmt:sub(ms, i-1)
            if fmt:sub(i,i) == "}" then i = i+1 end
            segs[#segs+1] = {type="cap", index=idx, modifier=mod}

          elseif mc == "+" then
            -- ${N:+if_set}
            i = i+1
            local vs = i
            while i <= len and fmt:sub(i,i) ~= "}" do i = i+1 end
            local val = fmt:sub(vs, i-1)
            if fmt:sub(i,i) == "}" then i = i+1 end
            segs[#segs+1] = {type="if_set", index=idx, value=val}

          elseif mc == "?" then
            -- ${N:?if_set:if_not}
            i = i+1
            local vs = i
            while i <= len and fmt:sub(i,i) ~= ":" and fmt:sub(i,i) ~= "}" do i = i+1 end
            local if_set = fmt:sub(vs, i-1)
            local if_not = ""
            if fmt:sub(i,i) == ":" then
              i = i+1
              local vns = i
              while i <= len and fmt:sub(i,i) ~= "}" do i = i+1 end
              if_not = fmt:sub(vns, i-1)
            end
            if fmt:sub(i,i) == "}" then i = i+1 end
            segs[#segs+1] = {type="cond", index=idx, if_set=if_set, if_not=if_not}

          elseif mc == "-" then
            -- ${N:-default}
            i = i+1
            local ds = i
            while i <= len and fmt:sub(i,i) ~= "}" do i = i+1 end
            local def = fmt:sub(ds, i-1)
            if fmt:sub(i,i) == "}" then i = i+1 end
            segs[#segs+1] = {type="default", index=idx, default=def}

          else
            while i <= len and fmt:sub(i,i) ~= "}" do i = i+1 end
            if fmt:sub(i,i) == "}" then i = i+1 end
            segs[#segs+1] = {type="cap", index=idx}
          end
        else
          if fmt:sub(i,i) == "}" then i = i+1 end
          segs[#segs+1] = {type="cap", index=idx}
        end
      else
        -- bare $N
        local s = i
        while i <= len and fmt:sub(i,i):match("%d") do i = i+1 end
        local idx = tonumber(fmt:sub(s, i-1)) or 0
        segs[#segs+1] = {type="cap", index=idx}
      end
    else
      text = text .. ch; i = i+1
    end
  end
  flush()
  return segs
end

-- Apply a parsed format segment list against a matchlist result.
-- `captures`: vim.fn.matchlist return — [1]=full match, [2]=group1, etc.
local function apply_format(segs, captures)
  local parts = {}
  for _, seg in ipairs(segs) do
    if seg.type == "lit" then
      parts[#parts+1] = seg.value

    elseif seg.type == "cap" then
      local val = captures[seg.index + 1] or ""
      if seg.modifier then
        local fn = modifiers[seg.modifier]
        val = fn and fn(val) or val
      end
      parts[#parts+1] = val

    elseif seg.type == "if_set" then
      if (captures[seg.index + 1] or "") ~= "" then
        parts[#parts+1] = seg.value
      end

    elseif seg.type == "cond" then
      parts[#parts+1] = (captures[seg.index + 1] or "") ~= ""
        and seg.if_set or seg.if_not

    elseif seg.type == "default" then
      local val = captures[seg.index + 1] or ""
      parts[#parts+1] = val ~= "" and val or seg.default
    end
  end
  return table.concat(parts)
end

-- Translate common ECMAScript-isms to Vim very-magic equivalents.
-- \v mode already handles: (group), +, ?, |, {n,m}, \d \w \s
-- We only need to patch the things that differ.
local function ecma_to_vim(pattern)
  -- non-capturing groups: (?:...) → \%(...)   [in \v mode: %(...)]
  pattern = pattern:gsub("%(%?:", "%%(")
  -- lookahead/behind: strip (?=...) (?!...) (?<=...) (?<!...)
  -- (approximate — Vim has \@= \@! \@<= \@<! but the translation is complex;
  --  for the 99% of real-world snippet transforms this is not needed)
  return pattern
end

-- Apply a transform: run regex against source_text, replace with format.
-- Handles global flag by looping; zero-width match protection included.
local function apply_transform(source_text, regex, format_segs, flags)
  local vim_pat = "\\v" .. ecma_to_vim(regex)
  if flags:find("i") then vim_pat = "\\c" .. vim_pat end
  local global  = flags:find("g") ~= nil

  if not global then
    local caps = vim.fn.matchlist(source_text, vim_pat)
    if #caps == 0 then return source_text end
    local ms = vim.fn.match(source_text, vim_pat)
    local me = ms + #caps[1]
    return source_text:sub(1, ms)
        .. apply_format(format_segs, caps)
        .. source_text:sub(me + 1)
  end

  -- global: loop, protect against infinite loop on zero-width matches
  local result, remaining = {}, source_text
  while remaining ~= "" do
    local caps = vim.fn.matchlist(remaining, vim_pat)
    if #caps == 0 then result[#result+1] = remaining; break end
    local ms = vim.fn.match(remaining, vim_pat)
    local me = ms + #caps[1]
    result[#result+1] = remaining:sub(1, ms)
    result[#result+1] = apply_format(format_segs, caps)
    remaining = remaining:sub(me + 1)
    if #caps[1] == 0 then  -- zero-width match: advance one byte
      if remaining ~= "" then result[#result+1] = remaining:sub(1,1) end
      remaining = remaining:sub(2)
    end
  end
  return table.concat(result)
end

-- ============================================================================
-- PARSER
-- Nodes:
--   {type="text",      value=str}
--   {type="tabstop",   index=N, children=[nodes]}
--   {type="choice",    index=N, choices=[str,...]}
--   {type="transform", source=N, regex=str, format_segs=[...], flags=str}
-- ============================================================================

local VARS = {
  TM_FILENAME      = function() return vim.fn.expand("%:t")            end,
  TM_FILENAME_BASE = function() return vim.fn.expand("%:t:r")          end,
  TM_DIRECTORY     = function() return vim.fn.expand("%:p:h")          end,
  TM_FILEPATH      = function() return vim.fn.expand("%:p")            end,
  TM_LINE_NUMBER   = function() return tostring(vim.fn.line("."))      end,
  TM_CURRENT_LINE  = function() return vim.api.nvim_get_current_line() end,
  TM_CURRENT_WORD  = function() return vim.fn.expand("<cword>")        end,
  CLIPBOARD        = function() return vim.fn.getreg("+")              end,
  CURRENT_YEAR     = function() return os.date("%Y")                   end,
  CURRENT_MONTH    = function() return os.date("%m")                   end,
  CURRENT_DATE     = function() return os.date("%d")                   end,
}

local function parse(src)
  local pos, len = 1, #src

  local function peek()  return src:sub(pos, pos) end
  local function eat(n)  pos = pos + (n or 1)     end

  local function read_int()
    local s = pos
    while pos <= len and src:sub(pos,pos):match("%d") do pos = pos+1 end
    if pos == s then return nil end
    return tonumber(src:sub(s, pos-1))
  end

  local function read_ident()
    local s = pos
    while pos <= len and src:sub(pos,pos):match("[%w_]") do pos = pos+1 end
    if pos == s then return nil end
    return src:sub(s, pos-1)
  end

  -- Read raw text until an unescaped `stop` char, consuming the stop char.
  local function read_until(stop)
    local parts, s = {}, pos
    while pos <= len do
      local ch = src:sub(pos,pos)
      if ch == "\\" and pos < len then
        parts[#parts+1] = src:sub(s, pos-1)
        pos = pos+1
        parts[#parts+1] = src:sub(pos,pos)
        pos = pos+1
        s = pos
      elseif ch == stop then
        parts[#parts+1] = src:sub(s, pos-1)
        pos = pos+1  -- consume stop
        return table.concat(parts)
      else
        pos = pos+1
      end
    end
    parts[#parts+1] = src:sub(s, pos-1)
    return table.concat(parts)
  end

  local parse_nodes  -- forward declaration

  local function parse_choice(index)
    local choices, cur = {}, ""
    while pos <= len do
      local ch = peek()
      if ch == "\\" and pos < len then
        eat(); cur = cur .. peek(); eat()
      elseif ch == "," then
        choices[#choices+1] = cur; cur = ""; eat()
      elseif ch == "|" then
        choices[#choices+1] = cur; eat()
        if peek() == "}" then eat() end
        break
      else cur = cur .. ch; eat() end
    end
    return {type="choice", index=index, choices=choices}
  end

  parse_nodes = function(stop_char)
    local nodes, text = {}, ""

    local function flush()
      if text ~= "" then nodes[#nodes+1]={type="text",value=text}; text="" end
    end

    while pos <= len do
      if stop_char and peek() == stop_char then break end
      local ch = peek()

      if ch == "\\" and pos < len then
        eat(); text = text .. peek(); eat()

      elseif ch == "$" then
        flush(); eat()

        if peek() == "{" then
          eat()
          local index = read_int()

          if index then
            local nc = peek()
            if nc == "}" then
              eat()
              nodes[#nodes+1] = {type="tabstop", index=index, children={}}

            elseif nc == ":" then
              eat()
              local children = parse_nodes("}")
              if peek() == "}" then eat() end
              nodes[#nodes+1] = {type="tabstop", index=index, children=children}

            elseif nc == "|" then
              eat()
              nodes[#nodes+1] = parse_choice(index)

            elseif nc == "/" then
              eat()  -- /
              local regex      = read_until("/")
              local format_raw = read_until("/")
              local flags      = read_until("}")
              nodes[#nodes+1] = {
                type        = "transform",
                source      = index,
                regex       = regex,
                format_segs = parse_format(format_raw),
                flags       = flags,
              }

            else
              local depth = 1
              while pos <= len and depth > 0 do
                if peek()=="{"then depth=depth+1 elseif peek()=="}"then depth=depth-1 end
                eat()
              end
            end

          else
            local name = read_ident() or ""
            local default_nodes = {}
            if peek() == ":" then eat(); default_nodes = parse_nodes("}")
            elseif peek() == "/" then eat(); read_until("/"); read_until("/"); read_until("}"); goto var_done end
            if peek() == "}" then eat() end
            ::var_done::
            local fn = VARS[name]
            if fn then nodes[#nodes+1] = {type="text", value=fn()}
            elseif #default_nodes > 0 then
              for _, n in ipairs(default_nodes) do nodes[#nodes+1] = n end
            end
          end

        else
          local index = read_int()
          if index then
            nodes[#nodes+1] = {type="tabstop", index=index, children={}}
          else
            local name = read_ident() or ""
            local fn = VARS[name]
            if fn then nodes[#nodes+1] = {type="text", value=fn()} end
          end
        end

      else text = text .. ch; eat() end
    end
    flush()
    return nodes
  end

  return parse_nodes(nil)
end

-- ============================================================================
-- FLATTEN  (two-phase: collect defaults first, then lay out with transforms)
--
-- Phase 1 — collect_defaults: fast text-only walk, no position tracking.
--   Returns defaults[index] = default_text for every tabstop/choice node.
--
-- Phase 2 — flatten_nodes: full walk, O(n) via running offset.
--   Writes out_ts[index]   = list of {start, stop, default, choices?}
--   Writes out_xf[source]  = list of {start, stop, regex, format_segs, flags}
--   Transforms resolved using defaults collected in phase 1.
-- ============================================================================

local function collect_defaults(nodes, defs)
  defs = defs or {}
  for _, node in ipairs(nodes) do
    if node.type == "tabstop" then
      if not defs[node.index] then
        -- flatten children text-only (no position tracking)
        local parts = {}
        local function text_of(nl)
          for _, n in ipairs(nl) do
            if n.type == "text" then parts[#parts+1] = n.value
            elseif n.type == "tabstop" or n.type == "choice" then
              if n.type == "choice" then
                parts[#parts+1] = (n.choices and n.choices[1]) or ""
              else text_of(n.children or {}) end
            end
          end
        end
        text_of(node.children or {})
        defs[node.index] = table.concat(parts)
        collect_defaults(node.children or {}, defs)
      end
    elseif node.type == "choice" then
      if not defs[node.index] then
        defs[node.index] = (node.choices and node.choices[1]) or ""
      end
    end
  end
  return defs
end

local function flatten_nodes(nodes, base, out_ts, out_xf, defs)
  local parts  = {}
  local offset = base

  for _, node in ipairs(nodes) do
    if node.type == "text" then
      parts[#parts+1] = node.value
      offset = offset + #node.value

    elseif node.type == "tabstop" then
      local start      = offset
      local child_text = flatten_nodes(node.children or {}, start, out_ts, out_xf, defs)
      parts[#parts+1] = child_text
      offset           = offset + #child_text
      if not out_ts[node.index] then out_ts[node.index] = {} end
      out_ts[node.index][#out_ts[node.index]+1] = {
        start   = start,
        stop    = offset,
        default = child_text,
      }

    elseif node.type == "choice" then
      local start = offset
      local first = (node.choices and node.choices[1]) or ""
      parts[#parts+1] = first
      offset = offset + #first
      if not out_ts[node.index] then out_ts[node.index] = {} end
      out_ts[node.index][#out_ts[node.index]+1] = {
        start   = start,
        stop    = offset,
        default = first,
        choices = node.choices,
      }

    elseif node.type == "transform" then
      -- Resolve now using the source tabstop's default (from phase-1 pre-pass)
      local source_val = defs[node.source] or ""
      local result     = apply_transform(source_val, node.regex, node.format_segs, node.flags)
      local start      = offset
      parts[#parts+1] = result
      offset           = offset + #result
      if not out_xf[node.source] then out_xf[node.source] = {} end
      out_xf[node.source][#out_xf[node.source]+1] = {
        start       = start,
        stop        = offset,
        regex       = node.regex,
        format_segs = node.format_segs,
        flags       = node.flags,
      }
    end
  end

  return table.concat(parts)
end

local function flatten(nodes)
  local defs   = collect_defaults(nodes)
  local out_ts = {}
  local out_xf = {}
  local text   = flatten_nodes(nodes, 0, out_ts, out_xf, defs)
  return text, out_ts, out_xf
end

-- ============================================================================
-- POSITION MATH (precomputed line lengths → O(lines) per call, not O(n²))
-- ============================================================================

local function make_line_lens(lines)
  local lens = {}
  for i, l in ipairs(lines) do lens[i] = #l end
  return lens
end

local function byte_to_rowcol(byte, line_lens, base_row, base_col)
  local remaining = byte
  for i, ll in ipairs(line_lens) do
    local col_base = (i == 1) and base_col or 0
    if i == #line_lens or remaining <= ll then
      return base_row + i - 1, col_base + remaining
    end
    remaining = remaining - ll - 1
  end
  local col_base = (#line_lens == 1) and base_col or 0
  return base_row + #line_lens - 1, col_base + line_lens[#line_lens]
end

-- ============================================================================
-- EXTMARK HELPERS (pcall-free hot path)
-- ============================================================================

local function mark_pos(bufnr, id)
  local r = nvim_buf_get_extmark(bufnr, ns, id, {})
  if r and #r == 2 then return r[1], r[2] end
  return nil, nil
end

local function region_text(bufnr, s_id, e_id)
  local sr, sc = mark_pos(bufnr, s_id)
  local er, ec = mark_pos(bufnr, e_id)
  if not sr then return "" end
  local lines = nvim_buf_get_lines(bufnr, sr, er+1, false)
  if #lines == 0 then return "" end
  if sr == er then return lines[1]:sub(sc+1, ec) end
  lines[1]      = lines[1]:sub(sc+1)
  lines[#lines] = lines[#lines]:sub(1, ec)
  return table.concat(lines, "\n")
end

local function set_region_text(bufnr, s_id, e_id, text)
  local sr, sc = mark_pos(bufnr, s_id)
  local er, ec = mark_pos(bufnr, e_id)
  if not sr then return end
  nvim_buf_set_text(bufnr, sr, sc, er, ec, vim.split(text, "\n", {plain=true}))
end

-- ============================================================================
-- CHOICE UI
-- Float near cursor, <C-n>/<C-p> navigate live, <CR>/<Tab> confirm, <Esc> cancel.
-- ============================================================================

local choice_state = nil

local function close_choice_ui()
  if not choice_state then return end
  for _, km in ipairs(choice_state.saved_maps) do
    if km.lhs then
      if km.callback then
        vim.keymap.set("i", km.lhs, km.callback, {buffer=km.buffer, silent=true})
      elseif km.rhs and km.rhs ~= "" then
        vim.keymap.set("i", km.lhs, km.rhs, {buffer=km.buffer, silent=true, expr=km.expr==1})
      else
        pcall(vim.keymap.del, "i", km.lhs, {buffer=km.buffer})
      end
    end
  end
  pcall(vim.api.nvim_win_close, choice_state.win,  true)
  pcall(vim.api.nvim_buf_delete, choice_state.buf, {force=true})
  choice_state = nil
end

local function render_choice_float(buf, choices, selected)
  local lines = {}
  for i, ch in ipairs(choices) do
    lines[#lines+1] = (i == selected and " ▶ " or "   ") .. ch
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  vim.api.nvim_buf_add_highlight(buf, ns, "CursorLine", selected-1, 0, -1)
end

local function open_choice_ui(bufnr, ts, session)
  local choices = ts.choices
  if not choices or #choices == 0 then return end
  close_choice_ui()

  local selected = 1
  local max_w    = 4
  for _, ch in ipairs(choices) do max_w = math.max(max_w, #ch + 4) end

  local float_buf = vim.api.nvim_create_buf(false, true)
  local sr, sc    = mark_pos(bufnr, ts.start_id)
  local win       = vim.api.nvim_open_win(float_buf, false, {
    relative  = "buf",
    buf       = bufnr,
    bufpos    = {sr, sc},
    row       = 1,
    col       = 0,
    width     = max_w,
    height    = #choices,
    style     = "minimal",
    border    = "rounded",
    focusable = false,
    zindex    = 200,
  })
  vim.wo[win].wrap = false
  render_choice_float(float_buf, choices, selected)

  local function apply(idx)
    selected = idx
    render_choice_float(float_buf, choices, selected)
    local saved = nvim_win_get_cursor(0)
    session._jumping = true
    set_region_text(bufnr, ts.start_id, ts.end_id, choices[selected])
    -- mirror to linked occurrences
    local list = session.tabstops[session.current]
    if list then
      for i = 2, #list do
        set_region_text(bufnr, list[i].start_id, list[i].end_id, choices[selected])
      end
    end
    session._jumping = false
    pcall(nvim_win_set_cursor, 0, saved)
  end

  local intercept = {"<C-n>", "<C-p>", "<CR>", "<Tab>", "<Esc>"}
  local saved_maps = {}
  for _, key in ipairs(intercept) do
    local m = vim.fn.maparg(key, "i", false, true)
    m.buffer = bufnr
    saved_maps[#saved_maps+1] = m
  end

  local o = {buffer=bufnr, silent=true, nowait=true}
  vim.keymap.set("i", "<C-n>",  function() apply(selected < #choices and selected+1 or 1) end, o)
  vim.keymap.set("i", "<C-p>",  function() apply(selected > 1 and selected-1 or #choices) end, o)
  vim.keymap.set("i", "<CR>",   close_choice_ui, o)
  vim.keymap.set("i", "<Tab>",  close_choice_ui, o)
  vim.keymap.set("i", "<Esc>",  function() apply(1); close_choice_ui() end, o)

  choice_state = {win=win, buf=float_buf, saved_maps=saved_maps, bufnr=bufnr}
end

-- ============================================================================
-- SESSION
-- ============================================================================

local session = nil

local function session_destroy()
  if not session then return end
  close_choice_ui()
  pcall(vim.api.nvim_del_augroup_by_id, session.aug)
  pcall(vim.api.nvim_buf_clear_namespace, session.bufnr, ns, 0, -1)
  session = nil
end

local function sort_indices(ts)
  local idxs = {}
  for k in pairs(ts) do idxs[#idxs+1] = k end
  table.sort(idxs, function(a, b)
    if a == 0 then return false end
    if b == 0 then return true  end
    return a < b
  end)
  return idxs
end

-- Update all transforms sourced from `index` using the current text of that tabstop.
local function update_transforms(index)
  if not session then return end
  local xf_list = session.transforms[index]
  if not xf_list or #xf_list == 0 then return end
  local ts_list = session.tabstops[index]
  if not ts_list or #ts_list == 0 then return end

  local source_text = region_text(session.bufnr, ts_list[1].start_id, ts_list[1].end_id)
  local saved = nvim_win_get_cursor(0)
  session._jumping = true
  for _, xf in ipairs(xf_list) do
    local result = apply_transform(source_text, xf.regex, xf.format_segs, xf.flags)
    set_region_text(session.bufnr, xf.start_id, xf.end_id, result)
  end
  session._jumping = false
  pcall(nvim_win_set_cursor, 0, saved)
end

local function select_tabstop(bufnr, ts)
  local sr, sc = mark_pos(bufnr, ts.start_id)
  local er, ec = mark_pos(bufnr, ts.end_id)
  if not sr then return end

  if sr == er and sc == ec then
    nvim_win_set_cursor(0, {sr+1, sc})
    if vim.fn.mode() ~= "i" then vim.cmd("startinsert") end
    return
  end

  if sr == er then
    nvim_win_set_cursor(0, {sr+1, sc})
    local ctrl_g = vim.api.nvim_replace_termcodes("<C-G>", true, false, true)
    local motion  = "v" .. (ec-sc > 1 and string.rep("l", ec-sc-1) or "") .. ctrl_g
    vim.fn.feedkeys(motion, "n")
  else
    nvim_win_set_cursor(0, {sr+1, sc})
    if vim.fn.mode() ~= "i" then vim.cmd("startinsert") end
  end
end

local function activate(index)
  if not session then return end
  close_choice_ui()

  -- Before leaving current tabstop, fire transforms sourced from it
  if session.current ~= nil then
    update_transforms(session.current)
  end

  local ts_list = session.tabstops[index]
  if not ts_list or #ts_list == 0 then return end
  session.current  = index
  session._jumping = true
  local ts = ts_list[1]

  if ts.choices then
    local sr, sc = mark_pos(session.bufnr, ts.start_id)
    if sr then
      nvim_win_set_cursor(0, {sr+1, sc})
      if vim.fn.mode() ~= "i" then vim.cmd("startinsert") end
    end
    open_choice_ui(session.bufnr, ts, session)
  else
    select_tabstop(session.bufnr, ts)
  end

  vim.schedule(function() if session then session._jumping = false end end)
end

-- ============================================================================
-- EXPAND
-- ============================================================================

function M.expand(snippet_body)
  session_destroy()

  if type(snippet_body) == "table" then
    snippet_body = table.concat(snippet_body, "\n")
  end

  local ast             = parse(snippet_body)
  local text, out_ts, out_xf = flatten(ast)
  local lines           = vim.split(text, "\n", {plain=true})
  local line_lens       = make_line_lens(lines)
  local row0, col0      = unpack(nvim_win_get_cursor(0))
  row0 = row0 - 1

  -- Single atomic buffer write — no intermediate renders, no grow
  vim.api.nvim_buf_set_text(0, row0, col0, row0, col0, lines)

  local bufnr = vim.api.nvim_get_current_buf()

  -- Place extmark pairs for tabstops
  local sess_ts = {}
  for index, occurrences in pairs(out_ts) do
    sess_ts[index] = {}
    for _, occ in ipairs(occurrences) do
      local sr, sc = byte_to_rowcol(occ.start, line_lens, row0, col0)
      local er, ec = byte_to_rowcol(occ.stop,  line_lens, row0, col0)
      local s_id = vim.api.nvim_buf_set_extmark(bufnr, ns, sr, sc, {right_gravity=false, virt_text={}})
      local e_id = vim.api.nvim_buf_set_extmark(bufnr, ns, er, ec, {right_gravity=true,  virt_text={}})
      sess_ts[index][#sess_ts[index]+1] = {
        start_id = s_id, end_id = e_id, choices = occ.choices,
      }
    end
  end

  -- Place extmark pairs for transforms
  local sess_xf = {}
  for source, xfs in pairs(out_xf) do
    sess_xf[source] = {}
    for _, xf in ipairs(xfs) do
      local sr, sc = byte_to_rowcol(xf.start, line_lens, row0, col0)
      local er, ec = byte_to_rowcol(xf.stop,  line_lens, row0, col0)
      local s_id = vim.api.nvim_buf_set_extmark(bufnr, ns, sr, sc, {right_gravity=false, virt_text={}})
      local e_id = vim.api.nvim_buf_set_extmark(bufnr, ns, er, ec, {right_gravity=true,  virt_text={}})
      sess_xf[source][#sess_xf[source]+1] = {
        start_id    = s_id,
        end_id      = e_id,
        regex       = xf.regex,
        format_segs = xf.format_segs,
        flags       = xf.flags,
      }
    end
  end

  -- Synthesize $0 if absent
  if not sess_ts[0] then
    local er   = row0 + #lines - 1
    local ec   = (#lines == 1 and col0 or 0) + line_lens[#line_lens]
    local s_id = vim.api.nvim_buf_set_extmark(bufnr, ns, er, ec, {right_gravity=false, virt_text={}})
    local e_id = vim.api.nvim_buf_set_extmark(bufnr, ns, er, ec, {right_gravity=true,  virt_text={}})
    sess_ts[0] = {{start_id=s_id, end_id=e_id}}
  end

  local indices = sort_indices(sess_ts)

  session = {
    bufnr      = bufnr,
    tabstops   = sess_ts,
    transforms = sess_xf,  -- keyed by source tabstop index
    indices    = indices,
    current    = nil,
    _jumping   = false,
    aug        = vim.api.nvim_create_augroup("SnipEngine", {clear=true}),
  }

  -- Mirror: propagate edits from primary → linked occurrences (not transforms —
  -- those update only on jump for performance)
  vim.api.nvim_create_autocmd("TextChangedI", {
    group    = session.aug,
    buffer   = bufnr,
    callback = function()
      if not session or session._jumping then return end
      local cur_idx = session.current
      if not cur_idx then return end
      local list = session.tabstops[cur_idx]
      -- fast exits before any API calls
      if not list or #list < 2 then return end
      if choice_state then return end

      local crow, ccol = unpack(nvim_win_get_cursor(0))
      crow = crow - 1
      local sr, sc = mark_pos(bufnr, list[1].start_id)
      if not sr then return end
      local er, ec = mark_pos(bufnr, list[1].end_id)
      if not (  (crow > sr or (crow == sr and ccol >= sc))
            and (crow < er or (crow == er and ccol <= ec)) ) then return end

      local new_text = region_text(bufnr, list[1].start_id, list[1].end_id)
      local saved    = nvim_win_get_cursor(0)
      session._jumping = true
      for i = 2, #list do
        set_region_text(bufnr, list[i].start_id, list[i].end_id, new_text)
      end
      session._jumping = false
      pcall(nvim_win_set_cursor, 0, saved)
    end,
  })

  vim.api.nvim_create_autocmd({"InsertLeave", "BufLeave"}, {
    group    = session.aug,
    buffer   = bufnr,
    callback = function()
      if session and not session._jumping then session_destroy() end
    end,
  })

  activate(indices[1])
end

-- ============================================================================
-- JUMP API
-- ============================================================================

function M.active(direction)
  if not session then return false end
  for i, idx in ipairs(session.indices) do
    if idx == session.current then
      return direction > 0 and i < #session.indices or i > 1
    end
  end
  return false
end

function M.jump(direction)
  if not session then return false end
  local next_i = nil
  for i, idx in ipairs(session.indices) do
    if idx == session.current then
      next_i = i + (direction > 0 and 1 or -1)
      break
    end
  end
  if not next_i or next_i < 1 or next_i > #session.indices then return false end
  local next_idx = session.indices[next_i]
  activate(next_idx)
  if next_idx == 0 then vim.schedule(session_destroy) end
  return true
end

function M.get_session() return session    end
function M.destroy()     session_destroy() end

return M


