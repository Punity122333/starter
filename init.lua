if vim.env.KITTY_SCROLLBACK_NVIM == 'true' then
  -- Disable heavy UI/LSP plugins that slow down startup
  vim.g.loaded_matchit = 1
  vim.g.loaded_netrwPlugin = 1
  -- Add any other heavy plugins you want to skip here
end

-- Set PATH early to ensure all plugins can find executables
vim.env.PATH = vim.fn.expand("~/.npm-global/bin:") .. vim.env.PATH
vim.env.PATH = vim.fn.expand("~/.local/bin:") .. vim.env.PATH
vim.env.PATH = vim.fn.expand("~/.local/share/nvim/mason/bin:") .. vim.env.PATH


-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Force load LSP configuration after a short delay
vim.defer_fn(function()
  -- Ensure lspconfig is loaded
  pcall(require, "lspconfig")

  -- Trigger LSP attachment for current buffer if it's a code file
  local ft = vim.bo.filetype
  if ft ~= "" and ft ~= "lazy" and ft ~= "dashboard" then
    vim.cmd("doautocmd BufEnter")
  end
end, 300)
-- Inspect WHATEVER the mouse is touching
vim.keymap.set("n", "<leader>mi", function()
  local pos = vim.fn.getmousepos()
  -- If the mouse is in the statusline/winbar
  if pos.winid == 0 then return end
  
  local buf = vim.api.nvim_win_get_buf(pos.winid)
  local inspect_info = vim.inspect_pos(buf, pos.line - 1, pos.column - 1)
  print(vim.inspect(inspect_info))
end, { desc = "Inspect under mouse" })
-- This tells Neovim to look in the local luarocks folder for the magick module
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua;"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua;"
package.cpath = package.cpath .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/lib/lua/5.1/?.so;"
vim.opt.relativenumber = false
vim.opt.number = true -- This keeps absolute line numbers on

-- Fix treesitter "attempt to yield across C-call boundary" error
-- Disable conceal feature globally to prevent the error
vim.opt.conceallevel = 0
vim.opt.concealcursor = ""
vim.keymap.set("n", "hi", ":Inspect<CR>")
-- Fix the "abrupt edge" collision on floating windows by matching Term BG
-- Create an autocommand to force colors every time the theme loads
-- THE NUCLEAR FIX: Nuke all background colors for floating elements
-- Force ALL floating windows to match the main background color
-- THE GOD-LEVEL REPO FIX
-- THE ENGINE: Re-implementing transparent.nvim logic for a solid hex
-- THE ENGINE: Force-painting the entire UI to #1a1b26
-- THE GOD-HEX DYNAMIC ENGINE
local god_hex = "#1a1b26"
local selection_blue = "#28344a"

local function apply_god_theme()
  -- 1. CONTENT SENSING: Check if the current buffer contains sacred text
  local buf = vim.api.nvim_get_current_buf()
  local line_count = vim.api.nvim_buf_line_count(buf)
  -- We scan the first 100 lines for performance, usually enough for UI headers/content
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
    local low_name = name:lower()
    
    -- 2. THE ABSOLUTE PROTECTION (By Highlight Name)
    local is_protected_name = name:find("Border") or name:find("Prompt") or 
                         name:find("Visual") or name:find("CursorLine") or 
                         name:find("Search") or name:find("Pmenu") or 
                         name:find("Cmp") or name:find("Blink") or 
                         name:find("Float") or name:find("Kind") or 
                         name:find("Menu") or name:find("Wild") or 
                         name:find("Noice") or name:find("Lsp") or 
                         name:find("Msg") or name:find("Diagnostic") or 
                         name:find("lualine") or name:find("StatusLine") or 
                         name:find("Completion") or name:find("completion") or 
                         name:find("LSP") or name:find("lsp") or 
                         name:find("snippet") or name:find("Snippet") or 
                         name:find("NormalFloat") or name:find("Muted") or 
                         name:find("Text") or name:find("Avante") or name:find("Ask")

    -- 3. THE SELECTOR WELD
    local is_active_selector = name:find("Selected") and (name:find("SnacksPicker") or name:find("Telescope"))
                                  
    if is_active_selector or name == "CursorLine" then
       vim.api.nvim_set_hl(0, name, { bg = selection_blue, fg = hl.fg, force = true })
    else
      -- 4. THE VOID PASS (Now with Content Awareness)
      if hl.bg and not is_protected_name then
        -- If the buffer contains "Avante" or "Ask", we SKIP nuking the background
        -- This preserves the AI UI while keeping your code files in the void.
        if is_sacred_content then
          goto continue
        end

        local bg_color = (name:find("SnacksPicker") and not name:find("Selected")) and "NONE" or god_hex
        vim.api.nvim_set_hl(0, name, {
          bg = bg_color,
          fg = hl.fg, 
          blend = 0,
          force = true
        })
      end
    end
    ::continue::
  end

  -- 5. THE ULTIMATE HARD-LINKS (Same as before)
  vim.api.nvim_set_hl(0, "SnacksPickerSelected", { bg = selection_blue, force = true })
  vim.api.nvim_set_hl(0, "SnacksPickerFileSelected", { bg = selection_blue, force = true })
  vim.api.nvim_set_hl(0, "SnacksPickerDirSelected", { bg = selection_blue, force = true })
  vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = selection_blue, force = true })
  
  local sel_groups = { "BlinkCmpMenuSelection", "PmenuSel", "CmpItemAbbrSelected", "TelescopeSelection" }
  for _, g in ipairs(sel_groups) do
    vim.api.nvim_set_hl(0, g, { bg = selection_blue, force = true })
  end

  local float_groups = { "NormalFloat", "FloatTitle", "MsgArea", "StatusLine", "StatusLineNC" } 
  for _, g in ipairs(float_groups) do 
    vim.api.nvim_set_hl(0, g, { bg = god_hex, force = true }) 
  end

  local blink = {"BlinkCmpMenu" , "Separator"} 
  for _, g in ipairs(blink) do 
    vim.api.nvim_set_hl(0, g, { bg = "#16161e", blend = 20, force = true }) 
  end
end

-- THE TRIGGER
local god_group = vim.api.nvim_create_augroup("GodThemePersistence", { clear = true })
vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter", "BufWinEnter", "WinEnter", "CursorMoved" }, {
  group = god_group,
  callback = apply_god_theme,
})

apply_god_theme()