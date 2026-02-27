-- 1. Check for the NO_LAZY flag before anything else
local force_all = os.getenv("NO_LAZY") == "1"

if vim.env.KITTY_SCROLLBACK_NVIM == "true" then
  vim.g.loaded_matchit = 1
  vim.g.loaded_netrwPlugin = 1
end
vim.opt.foldenable = false

vim.env.PATH = vim.fn.expand("~/.npm-global/bin:") .. vim.env.PATH
vim.env.PATH = vim.fn.expand("~/.local/bin:") .. vim.env.PATH
vim.env.PATH = vim.fn.expand("~/.local/share/nvim/mason/bin:") .. vim.env.PATH

-- 2. Pass the flag into lazy (Ensure your config/lazy.lua uses this logic)
require("config.lazy")
-- Note: In your lua/config/lazy.lua, you should have:
-- defaults = { lazy = os.getenv("NO_LAZY") ~= "1" }

vim.defer_fn(function()
  pcall(require, "lspconfig")

  local ft = vim.bo.filetype
  if ft ~= "" and ft ~= "lazy" and ft ~= "dashboard" then
    -- Don't double-trigger if we already forced everything to load
    if not force_all then
      vim.cmd("doautocmd BufEnter")
    end
  end
end, 300)

vim.keymap.set("n", "<leader>mi", function()
  local pos = vim.fn.getmousepos()
  if pos.winid == 0 then
    return
  end

  local buf = vim.api.nvim_win_get_buf(pos.winid)
  local inspect_info = vim.inspect_pos(buf, pos.line - 1, pos.column - 1)
  print(vim.inspect(inspect_info))
end, { desc = "Inspect under mouse" })

if vim.fn.has("wayland") == 1 then
  vim.g.clipboard = {
    name = "wl-clipboard",
    copy = {
      ["+"] = "wl-copy",
      ["*"] = "wl-copy",
    },
    paste = {
      ["+"] = "wl-paste",
      ["*"] = "wl-paste",
    },
    cache_enabled = 1,
  }
end
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"
package.cpath = package.cpath .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/lib/lua/5.1/?.so;"

vim.opt.relativenumber = false
vim.opt.number = true
vim.g.VM_theme = "neon" -- or 'ocean', 'purplegray', 'spacegray'vim.opt.conceallevel = 0
vim.opt.concealcursor = ""
vim.keymap.set("n", "hi", ":Inspect<CR>")

-- Normal Mode (Cursor Mode) Highlighting
vim.cmd([[
  " This is the main cursor in VM Normal Mode
  highlight VM_Cursor guifg=#000000 guibg=#00f2ff gui=bold
         
  " This is the 'selection' or 'extension' highlight (the text you've grabbed)
  highlight VM_Extend_hl guibg=#224466 gui=italic
    
  " This is for the cursors specifically when you are in 'Extend' (Visual) mode
  highlight VM_Cursor_hl guifg=#000000 guibg=#00f2ff
]])
local god_hex = "#1a1b26"
local selection_blue = "#28344a"
local function apply_god_theme()
  local buf = vim.api.nvim_get_current_buf()
  local line_count = vim.api.nvim_buf_line_count(buf)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, math.min(line_count, 100), false)
  local is_sacred_content = false

  for _, line in ipairs(lines) do
    if line:find("Avante") or line:find("Ask") then
      is_sacred_content = true
      break
    end
  end

  local highlights = vim.api.nvim_get_hl(0, {})

  for name, hl in pairs(highlights) do
    local is_protected_name = name:find("Border")
      or name:find("Prompt")
      or name:find("Visual")
      or name:find("CursorLine")
      or name:find("Search")
      or name:find("Pmenu")
      or name:find("Cmp")
      or name:find("Blink")
      or name:find("Float")
      or name:find("Kind")
      or name:find("Menu")
      or name:find("Wild")
      or name:find("Noice")
      or name:find("Lsp")
      or name:find("Msg")
      or name:find("Diagnostic")
      or name:find("lualine")
      or name:find("StatusLine")
      or name:find("Completion")
      or name:find("completion")
      or name:find("LSP")
      or name:find("lsp")
      or name:find("snippet")
      or name:find("Snippet")
      or name:find("NormalFloat")
      or name:find("Muted")
      or name:find("Text")
      or name:find("Avante")
      or name:find("Ask")
      or name:find("VM")
      or name:find("Rainbow")
      or name:find("LazyReason")
      or name:find("Lsp")

    local is_active_selector = name:find("Selected") and (name:find("SnacksPicker") or name:find("Telescope"))

    if is_active_selector or name == "CursorLine" then
      vim.api.nvim_set_hl(0, name, { bg = selection_blue, fg = hl.fg, force = true })
    else
      if hl.bg and not is_protected_name then
        if is_sacred_content then
          goto continue
        end

        local bg_color = (name:find("SnacksPicker") and not name:find("Selected")) and "NONE" or god_hex
        vim.api.nvim_set_hl(0, name, {
          bg = bg_color,
          fg = hl.fg,
          blend = 0,
          force = true,
        })
        local profiler_color = (name:find("Profiler") or name:find("Benchmark")) and "NONE" or god_hex
        vim.api.nvim_set_hl(0, name, {
          bg = profiler_color,
          fg = hl.fg,
          blend = 0,
          force = true,
        })
      end
    end
    ::continue::
  end

  local sel_groups = { "BlinkCmpMenuSelection", "PmenuSel", "CmpItemAbbrSelected", "TelescopeSelection" }
  for _, g in ipairs(sel_groups) do
    vim.api.nvim_set_hl(0, g, { bg = selection_blue, force = true })
  end

  local float_groups = { "NormalFloat", "FloatTitle", "MsgArea", "StatusLine", "StatusLineNC" }
  for _, g in ipairs(float_groups) do
    vim.api.nvim_set_hl(0, g, { bg = god_hex, force = true })
  end

  local blink = { "BlinkCmpMenu", "BlinkCmpSignatureHelp", "NoiceLspSignatureHelp", "LspSignatureActiveParameter", "NoicePopup" }
  for _, g in ipairs(blink) do
    vim.api.nvim_set_hl(0, g, { bg = "#15151c", blend = 0, force = true })
  end
  vim.api.nvim_set_hl(0, "NoicePopupBorder", { bg = "#15151c", fg = "#232330", blend = 0, force = true })
  vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelpBorder", { bg = "#15151c", fg = "#232330", blend = 0, force = true })
  vim.api.nvim_set_hl(0, "LspInfoBorder", { bg = "#15151c", fg = "#232330", blend = 0, force = true })
  local sep = { "Split", "Splitter", "Separator", "WinSeparator", "VertSplit" }
  for _, g in ipairs(sep) do
    vim.api.nvim_set_hl(0, g, { bg = god_hex, blend = 20, fg = "#15151c", force = true })
  end
  vim.api.nvim_set_hl(0, "AvanteSidebarWinSeparator", { fg = "#15151c", bg = god_hex })
  vim.api.nvim_set_hl(0, "AvanteSidebarWinHorizontalSeparator", { fg = "#15151c", bg = god_hex })
  local snacks_selection_bg = "#1a1b26"
  vim.api.nvim_set_hl(0, "AvantePopup", { bg = "#15151c", force = true })
  local snack_hls = {
    SnacksPickerSelected = { bg = "NONE", fg = "#88c0d0" },
    SnacksPickerCursorLine = { bg = snacks_selection_bg },
  }
  for group, settings in pairs(snack_hls) do
    vim.api.nvim_set_hl(0, group, settings)
  end
  vim.api.nvim_set_hl(0, "AvantePromptInput", { bg = "#15151c", force = true })
  vim.api.nvim_set_hl(0, "AvantePromptInputBorder", { bg = "#15151c", force = true })

  vim.api.nvim_set_hl(0, "Cursor", { fg = "#000000", bg = "#00ff00", force = true })
  vim.api.nvim_set_hl(0, "lCursor", { fg = "#000000", bg = "#00ff00", force = true })
  vim.api.nvim_set_hl(0, "CursorIM", { fg = "#000000", bg = "#00ff00", force = true })
  vim.api.nvim_set_hl(0, "TermCursor", { fg = "#000000", bg = "#00ff00", force = true })
  vim.opt.guicursor = "n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor"
end

local god_group = vim.api.nvim_create_augroup("GodThemePersistence", { clear = true })
vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter", "BufWinEnter" }, {
  group = god_group,
  callback = apply_god_theme,
})

apply_god_theme()
