-- GLSL linting with glslangValidator for enhanced diagnostics
return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      
      -- Configure the glslangValidator linter
      lint.linters.glslangValidator = {
        cmd = "glslangValidator",
        stdin = false, -- glslangValidator works on files
        args = function()
          -- Determine file type and add appropriate flag
          local ext = vim.fn.expand("%:e")
          local stage_map = {
            vert = "vert",
            frag = "frag",
            tesc = "tesc",
            tese = "tese",
            geom = "geom",
            comp = "comp",
            glsl = "vert", -- Default to vertex shader for .glsl
          }
          
          local stage = stage_map[ext] or "vert"
          return { "-S", stage, vim.api.nvim_buf_get_name(0) }
        end,
        stream = "stderr",
        ignore_exitcode = true,
        parser = function(output, bufnr)
          local diagnostics = {}
          
          -- Parse glslangValidator output
          -- Format: ERROR: filename:line: message
          -- Format: WARNING: filename:line: message
          for line in output:gmatch("[^\r\n]+") do
            -- Try to match the standard format
            local severity, file, lnum, msg = line:match("^(%w+):%s*(.-):%s*(%d+):%s*(.+)$")
            
            if severity and lnum and msg then
              local diagnostic_severity = vim.diagnostic.severity.ERROR
              if severity == "WARNING" then
                diagnostic_severity = vim.diagnostic.severity.WARN
              elseif severity == "INFO" then
                diagnostic_severity = vim.diagnostic.severity.INFO
              end
              
              table.insert(diagnostics, {
                lnum = tonumber(lnum) - 1, -- 0-indexed
                col = 0,
                end_lnum = tonumber(lnum) - 1,
                end_col = 0,
                message = msg:gsub("^'([^']+)'%s*:%s*", ""), -- Clean up message
                severity = diagnostic_severity,
                source = "glslangValidator",
              })
            end
          end
          
          return diagnostics
        end,
      }
      
      -- Set up linters by filetype
      lint.linters_by_ft = {
        glsl = { "glslangValidator" },
        vert = { "glslangValidator" },
        frag = { "glslangValidator" },
        tesc = { "glslangValidator" },
        tese = { "glslangValidator" },
        geom = { "glslangValidator" },
        comp = { "glslangValidator" },
      }
      
      -- Set up autocmds to trigger linting
      local lint_augroup = vim.api.nvim_create_augroup("nvim_lint_glsl", { clear = true })
      
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave", "TextChanged" }, {
        group = lint_augroup,
        callback = function()
          -- Only lint GLSL files
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
