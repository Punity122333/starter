local COLOR_LINE_NUMBER = "#565f89"
local COLOR_NONE = "none"

vim.api.nvim_set_hl(0, "SignColumn", { bg = COLOR_NONE })
vim.api.nvim_set_hl(0, "LineNr", { fg = COLOR_LINE_NUMBER, bg = COLOR_NONE })
vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = COLOR_NONE, bg = COLOR_NONE })

-- Buffer-local code action timer
local codeaction_timers = {}
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    if client.offset_encoding then
      client.offset_encoding = "utf-16"
    end

    if not client.server_capabilities.codeActionProvider then
      return
    end

    local excluded_servers = { html = true, cssls = true, eslint = true }
    if excluded_servers[client.name] then
      return
    end

    vim.api.nvim_create_autocmd("CursorHold", {
      buffer = args.buf,
      callback = function()
        if codeaction_timers[args.buf] then
          vim.fn.timer_stop(codeaction_timers[args.buf])
        end

        codeaction_timers[args.buf] = vim.fn.timer_start(300, function()
          local params = vim.lsp.util.make_range_params(nil, "utf-16")
          params.context = { diagnostics = vim.lsp.diagnostic.get_line_diagnostics() }

          vim.lsp.buf_request(args.buf, "textDocument/codeAction", params, function() end)
        end)
      end,
    })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "avante", "avante-input" },
  callback = function()
    vim.opt_local.conceallevel = 2
    vim.opt_local.concealcursor = "nc"
  end,
})

-- Refresh Avante when a code buffer is deleted
vim.api.nvim_create_autocmd("BufDelete", {
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    if ft ~= "avante" and ft ~= "avante-input" then
      vim.schedule(function()
        local ok, avante_api = pcall(require, "avante.api")
        if ok and avante_api.refresh then
          pcall(avante_api.refresh)
        else
          vim.cmd("AvanteRefresh")
        end
      end)
    end
  end,
  desc = "Refresh Avante when a code buffer is deleted",
})

local vm_augroup = vim.api.nvim_create_augroup("VMLagFix", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "cpp" },
  callback = function(args)
    vim.cmd("redraw!")
    vim.api.nvim_set_current_buf(args.buf)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "spectre_panel",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    vim.opt_local.cindent = false
    vim.opt_local.smartindent = true 
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    local lines = vim.api.nvim_buf_line_count(args.buf)
    if lines > 5000 then
      vim.b.autoformat = false
    end
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == "rust-analyzer" then
            client.offset_encoding = "utf-8"
        end
    end,
})

vim.opt.updatetime = 1000 

local rust_clippy_group = vim.api.nvim_create_augroup("RustAutoClippy", { clear = true })

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = rust_clippy_group,
    pattern = "*.rs",
    callback = function()
        if vim.bo.modified then
            vim.cmd("silent! noautocmd write")
            vim.cmd("RustLsp flyCheck")
        end
    end,
})

local snacks_refresh_group = vim.api.nvim_create_augroup("SnacksExplorerRefresh", { clear = true })

vim.api.nvim_create_autocmd("DiagnosticChanged", {
    group = snacks_refresh_group,
    callback = function()
        local explorers = require("snacks").picker.get({ source = "explorer" })
        for _, picker in ipairs(explorers) do
            picker:find() 
        end
    end,
})
