return {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
        opts.options = vim.tbl_deep_extend("force", opts.options or {}, {
            globalstatus = true,
            refresh = {
                statusline = 100000,
                tabline    = 100000,
                winbar     = 100000,
            },
        })
        opts.sections = opts.sections or {}

        opts.sections.lualine_a = {
            {
                "mode",
                color = { gui = "bold" },
                fmt = function(str)
                    local ok, engine = pcall(require, "modules.completion.engine")
                    if ok and engine.get_session() then
                        return "SNIPPET"
                    end
                    return str
                end,
            },
        }

        opts.sections.lualine_z = {
            {
                function()
                    return os.date("%H:%M")
                end,
                color = { gui = "bold" },
            },
        }

        return opts
    end,
}
