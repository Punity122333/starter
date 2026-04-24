return {
    "j-hui/fidget.nvim",
    lazy = false,
    opts = {
        progress = {
            poll_rate = 125,
            ignore_done_already = true,
            ignore_empty_message = true,
            display = {
                render_limit = 1,
                done_ttl = 1,
                done_icon = "✓",
                spinner = "dots",
            },
        },
        notification = {
            poll_rate = 125,
            filter = vim.log.levels.INFO,
            override_vim_notify = false,
            window = {
                winblend = 0,
                zindex = 45,
                max_width = 50,
                max_height = 1,
                x_padding = 0,
                y_padding = 0,
                align = "top",
                relative = "editor",
            },
        },
    },
    config = function(_, opts)
        -- Try to require the plugin safely.
        local ok_req, mod_or_err = pcall(require, "fidget")
        if not ok_req then
            local cache = vim.fn.stdpath("cache")
            local path = cache .. "/fidget_require_error.log"
            local fd = io.open(path, "a")
            if fd then
                fd:write(os.date("%Y-%m-%d %H:%M:%S") .. " - require('fidget') failed: " .. tostring(mod_or_err) .. "\n")
                fd:close()
            end
            vim.schedule(function()
                vim.notify("fidget.nvim failed to load. See: " .. path, vim.log.levels.ERROR)
            end)
            return
        end

        -- Try to run setup with options safely.
        local ok_setup, setup_err = pcall(mod_or_err.setup, opts)
        if not ok_setup then
            local cache = vim.fn.stdpath("cache")
            local path = cache .. "/fidget_setup_error.log"
            local fd = io.open(path, "a")
            if fd then
                fd:write(os.date("%Y-%m-%d %H:%M:%S") .. " - fidget.setup failed: " .. tostring(setup_err) .. "\n")
                fd:close()
            end
            vim.schedule(function()
                vim.notify("fidget.nvim setup failed. See: " .. path, vim.log.levels.ERROR)
            end)
            return
        end
    end,
}
