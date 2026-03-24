return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        explorer = {
            enabled = true,
            cycle = false,
            win = {
                layout = {
                    position = "right",
                    width = 0.15,
                },
            },
        },
        styles = {
            backdrop = {
                transparent = false,
                blend = 0,
            },
        },
        picker = {
            enabled = true,
            ui_select = true, -- snacks handles vim.ui.select for better ui
            icons = {
                selected = "󰄲 ",
                unselected = "󰄱 ",
                cursor = "❯ ",
            },
            layout = {
                preset = "default",
                preview = false,
                -- backdrop is handled by the global styles block above
            },
            exclude = {
                ".git",
                "node_modules",
                "**/*.lock",
                "package.json",
            },
            sources = {
                grep = {
                    finder = function(opts, ctx)
                        if #(ctx.filter.search or "") < 3 then
                            return {}
                        end
                        return require("snacks.picker.source.grep").grep(opts, ctx)
                    end,
                },
            },
        },
        input = { enabled = true },
        scroll = { enabled = false },
        statuscolumn = { enabled = true },
        words = { enabled = true },
        image = { enabled = true },
    },
    keys = {
        {
            "<leader>gg",
            function()
                Snacks.terminal("gitui")
            end,
            desc = "GitUI",
        },
    },
}
