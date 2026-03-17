local COLOR_BACKGROUND_PRIMARY = "#1a1b26"
local COLOR_SELECTION_BLUE = "#28344a"
local COLOR_MARKDOWN_BOLD = "#ff9e64"
local COLOR_DIAGNOSTIC_UNNECESSARY = "#6c7086"

local force_all = os.getenv("NO_LAZY") == "1"

vim.env.PATH = vim.fn.expand("~/.npm-global/bin:") .. vim.env.PATH
vim.env.PATH = vim.fn.expand("~/.local/bin:") .. vim.env.PATH
vim.env.PATH = vim.fn.expand("~/.local/share/nvim/mason/bin:") .. vim.env.PATH

require("config.lazy")
require("config.highlights")

vim.defer_fn(function()
  pcall(require, "lspconfig")

  local ft = vim.bo.filetype
  if ft ~= "" and ft ~= "lazy" and ft ~= "dashboard" then
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
vim.g.VM_SET_STATUS_LINE = 0
vim.opt.relativenumber = true
vim.opt.number = true
vim.g.VM_theme = "neon"
vim.opt.concealcursor = ""
vim.keymap.set("n", "hi", ":Inspect<CR>")
vim.g.VM_set_statusline = 0

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
      or name:find("TroubleCount")

    local is_active_selector = name:find("Selected") and (name:find("SnacksPicker") or name:find("Telescope"))
    if is_active_selector or name == "CursorLine" then
      vim.api.nvim_set_hl(0, name, { bg = COLOR_SELECTION_BLUE, fg = hl.fg, force = true })
    else
      if hl.bg and not is_protected_name then
        if is_sacred_content then
          goto continue
        end
        local bg_color = COLOR_BACKGROUND_PRIMARY
        if name:find("BlinkCmpKind") then
          bg_color = "NONE"
        elseif name:find("SnacksPicker") and not name:find("Selected") then
          bg_color = "NONE"
        elseif name:find("Profiler") or name:find("Benchmark") then
          bg_color = "NONE"
        end
        vim.api.nvim_set_hl(0, name, {
          bg = bg_color,
          fg = hl.fg,
          blend = 0,
          force = true,
        })
      end
    end
    ::continue::
  end
  vim.api.nvim_set_hl(0, "Cursor", { fg = "#000000", bg = "#00FF00" })
  vim.api.nvim_set_hl(0, "CursorInsert", { fg = "#000000", bg = "#00FF00" })
  local diag_underline_groups = {
    "DiagnosticUnderlineError",
    "DiagnosticUnderlineWarn",
    "DiagnosticUnderlineInfo",
    "DiagnosticUnderlineHint",
    "DiagnosticUnderlineOk",
  }
  for _, g in ipairs(diag_underline_groups) do
    local existing = vim.api.nvim_get_hl(0, { name = g })
    vim.api.nvim_set_hl(0, g, { sp = existing.sp, underline = true, bg = "NONE", force = true })
  end
  local illuminate_groups = {
    "IlluminatedWordText",
    "IlluminatedWordRead",
    "IlluminatedWordWrite",
    "LspReferenceText",
    "LspReferenceRead",
    "LspReferenceWrite",
  }
  for _, g in ipairs(illuminate_groups) do
    vim.api.nvim_set_hl(0, g, { bg = COLOR_SELECTION_BLUE, force = true })
  end
  vim.api.nvim_set_hl(0, "markdownBold", { fg = COLOR_MARKDOWN_BOLD, bold = true, force = true })
  vim.api.nvim_set_hl(0, "@markup.strong", { fg = COLOR_MARKDOWN_BOLD, bold = true, force = true })
  vim.api.nvim_set_hl(
    0,
    "DiagnosticUnnecessary",
    { fg = COLOR_DIAGNOSTIC_UNNECESSARY, strikethrough = true, force = true }
  )
  vim.api.nvim_set_hl(0, "BlinkCmpKindFile", { bg = "NONE", force = true })
  vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelpBorder", { fg = "#27a1b9", bg = COLOR_BACKGROUND_PRIMARY, force = true })
  vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelp", { bg = COLOR_BACKGROUND_PRIMARY, force = true })
  vim.api.nvim_set_hl(0, "BlinkCmpSignatureActiveParameter", { bg = COLOR_BACKGROUND_PRIMARY, force = true })
end

local GROUP_GOD_THEME_PERSISTENCE = vim.api.nvim_create_augroup("GodThemePersistence", { clear = true })
vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter", "BufWinEnter" }, {
  group = GROUP_GOD_THEME_PERSISTENCE,
  callback = apply_god_theme,
})

apply_god_theme()

vim.api.nvim_create_user_command("RefreshAll", function()
  vim.cmd("bufdo edit!")
end, { desc = "Reload all buffers from disk" })

vim.api.nvim_set_hl(0, "LspKindFile", { bg = "NONE", force = true })
vim.api.nvim_set_hl(0, "BlinkCmpKindFile", { bg = "NONE", force = true })

vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, 0 },
    }
  end
  require("conform").format({
    async = true,
    lsp_fallback = true,
    range = range,
  })
end, { range = true })

local saga_preview = require("lspsaga.definition")

local old_init = saga_preview.init_definition
saga_preview.init_definition = function(self, ...)
  vim.opt.lazyredraw = true

  old_init(self, ...)

  vim.schedule(function()
    vim.opt.lazyredraw = false
  end)
end
local original_notify = vim.notify
vim.notify = function(msg, level, opts)
  if type(msg) == "string" and msg:find("Avante") then
    return
  end
  original_notify(msg, level, opts)
end
