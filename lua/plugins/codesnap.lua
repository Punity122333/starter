return {
    {
        "mistricky/codesnap.nvim",
        build = "make build_generator",
        keys = {
            {
                "<leader>cc",
                function()
                    vim.api.nvim_feedkeys(
                        vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
                        "x",
                        false
                    )

                    local ok_gen, gen_module = pcall(require, "codesnap.module")
                    local ok_cfg, cfg_module = pcall(require, "codesnap.config")
                    if not ok_gen or not ok_cfg then
                        vim.notify("CodeSnap: plugin not loaded", vim.log.levels.ERROR)
                        return
                    end

                    local ok_conf, config = pcall(cfg_module.get_config)
                    if not ok_conf or not config then
                        vim.notify("CodeSnap: " .. tostring(config), vim.log.levels.WARN)
                        return
                    end

                    local tmp = "/tmp/codesnap_clipboard.png"
                    local ok_save, err = pcall(function()
                        gen_module.load_generator().save(tmp, config)
                    end)
                    if not ok_save then
                        vim.notify("CodeSnap: save failed — " .. tostring(err), vim.log.levels.ERROR)
                        return
                    end

                    local is_wayland = vim.env.WAYLAND_DISPLAY ~= nil and vim.env.WAYLAND_DISPLAY ~= ""
                    local cmd
                    if is_wayland then
                        cmd = "wl-copy --type image/png < " .. vim.fn.shellescape(tmp)
                    else
                        cmd = "xclip -selection clipboard -t image/png -i " .. vim.fn.shellescape(tmp)
                    end

                    vim.fn.jobstart(cmd, { detach = true })
                    vim.cmd("delmarks <>")
                    vim.notify("Snapshot copied to clipboard", vim.log.levels.INFO)
                end,
                mode = "v",
                desc = "Copy snap",
            },
            {
                "<leader>cl",
                function()
                    vim.api.nvim_feedkeys(
                        vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
                        "x",
                        false
                    )

                    local ok_gen, gen_module = pcall(require, "codesnap.module")
                    local ok_cfg, cfg_module = pcall(require, "codesnap.config")
                    if not ok_gen or not ok_cfg then
                        vim.notify("CodeSnap: plugin not loaded", vim.log.levels.ERROR)
                        return
                    end

                    local ok_conf, config = pcall(cfg_module.get_config)
                    if not ok_conf or not config then
                        vim.notify("CodeSnap: " .. tostring(config), vim.log.levels.WARN)
                        return
                    end

                    local default = vim.fn.expand("~/Pictures/codesnap.png")
                    vim.ui.input({ prompt = "Save snapshot to: ", default = default }, function(path)
                        if not path or path == "" then
                            vim.notify("CodeSnap: save cancelled", vim.log.levels.INFO)
                            return
                        end

                        path = vim.fn.expand(path)

                        local ok_save, err = pcall(function()
                            gen_module.load_generator().save(path, config)
                        end)
                        if not ok_save then
                            vim.notify("CodeSnap: save failed — " .. tostring(err), vim.log.levels.ERROR)
                            return
                        end

                        vim.cmd("delmarks <>")
                        vim.notify("Snapshot saved to " .. path, vim.log.levels.INFO)
                    end)
                end,
                mode = "v",
                desc = "Save snap",
            },
        },
        opts = {
            show_line_number = true,
            highlight_color = "#41486830",
            show_workspace = true,
            snapshot_config = {
                theme = "candy",
                window = {
                    mac_window_bar = true,
                    shadow = {
                        radius = 20,
                        color = "#00000060",
                    },
                    margin = { x = 82, y = 82 },
                    border = {
                        width = 1,
                        color = "#bb9af730",
                    },
                    title_config = {
                        color = "#c0caf5",
                        font_family = "FantasqueSansM Nerd Font",
                    },
                },
                themes_folders = {},
                fonts_folders = {},
                line_number_color = "#3b4261",
                command_output_config = {
                    prompt = "❯",
                    font_family = "FantasqueSansM Nerd Font",
                    prompt_color = "#f7768e",
                    command_color = "#9ece6a",
                    string_arg_color = "#e0af68",
                },
                code_config = {
                    font_family = "FantasqueSansM Nerd Font",
                    breadcrumbs = {
                        enable = true,
                        separator = "/",
                        color = "#565f89",
                        font_family = "FantasqueSansM Nerd Font",
                    },
                },
                watermark = {
                    content = "Pxnity",
                    font_family = "FantasqueSansM Nerd Font",
                    color = "#7aa2f7",
                },
                background = {
                    start = { x = 0, y = 0 },
                    ["end"] = { x = "max", y = 0 },
                    stops = {
                        { position = 0, color = "#1a1b26" },
                        { position = 1, color = "#24283b" }, 
                    },
                },
            },
        },
    },
}
