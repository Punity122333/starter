local GlslangEvent = { "BufReadPre", "BufNewFile" }
local GlslangCmd = "glslangValidator"
local GlslangStream = "stderr"
local GlslangIgnoreExitcode = true
local GlslangStageMap = {
  vert = "vert",
  frag = "frag",
  tesc = "tesc",
  tese = "tese",
  geom = "geom",
  comp = "comp",
  glsl = "vert",
}
return {
  {
    "mfussenegger/nvim-lint",
    event = GlslangEvent,
    config = function()
      local lint = require("lint")
      lint.linters.glslangValidator = {
        cmd = GlslangCmd,
        stdin = false,
        args = function()
          local ext = vim.fn.expand("%:e")
          local stage = GlslangStageMap[ext] or "vert"
          return { "-S", stage, vim.api.nvim_buf_get_name(0) }
        end,
        stream = GlslangStream,
        ignore_exitcode = GlslangIgnoreExitcode,
        parser = function(output, bufnr)
          local diagnostics = {}
          for line in output:gmatch("[^\r\n]+") do
            local severity, file, lnum, msg = line:match("^(%w+):%s*(.-):%s*(%d+):%s*(.+)$")
            if severity and lnum and msg then
              local diagnostic_severity = vim.diagnostic.severity.ERROR
              if severity == "WARNING" then
                diagnostic_severity = vim.diagnostic.severity.WARN
              elseif severity == "INFO" then
                diagnostic_severity = vim.diagnostic.severity.INFO
              end
              table.insert(diagnostics, {
                lnum = tonumber(lnum) - 1,
                col = 0,
                end_lnum = tonumber(lnum) - 1,
                end_col = 0,
                message = msg:gsub("^'([^']+)'%s*:%s*", ""),
                severity = diagnostic_severity,
                source = "glslangValidator",
                
              })
            end
          end
          return diagnostics
        end,
      }
      lint.linters_by_ft = {
        glsl = { "glslangValidator" },
        vert = { "glslangValidator" },
        frag = { "glslangValidator" },
        tesc = { "glslangValidator" },
        tese = { "glslangValidator" },
        geom = { "glslangValidator" },
        comp = { "glslangValidator" },
      }
      local lint_augroup = vim.api.nvim_create_augroup("nvim_lint_glsl", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave", "TextChanged" }, {
        group = lint_augroup,
        callback = function()
          local ft = vim.bo.filetype
          local glsl_filetypes = { "glsl", "vert", "frag", "tesc", "tese", "geom", "comp" }
          for _, glsl_ft in ipairs(glsl_filetypes) do
            if ft == glsl_ft then
              require("lint").try_lint()
              break
            end
          end
        end,
      })
    end,
  },
}
