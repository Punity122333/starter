return {
    {
        "mistricky/codesnap.nvim",
        build = "make build_generator",
        keys = {
            {
                "<leader>cc",
                function()
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
                    vim.cmd("CodeSnap")
                end,
                mode = "v",
                desc = "Copy snap",
            },
            {
                "<leader>cl",
                function()
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
                    vim.cmd("CodeSnapSave")
                end,
                mode = "v",
                desc = "Save snap",
            },
            {
                "<leader>ca",
                function()
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
                    vim.cmd("CodeSnapASCII")
                end,
                mode = "v",
                desc = "Copy snap (ASCII)",
            },
            {
                "<leader>ch",
                function()
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
                    vim.cmd("CodeSnapHighlight")
                end,
                mode = "v",
                desc = "Copy snap (highlight)",
            },
            {
                "<leader>ch",
                function()
                    vim.fn.setpos("'<", { 0, 1, 1, 0 })
                    vim.fn.setpos("'>", { 0, vim.api.nvim_buf_line_count(0), 1, 0 })
                    vim.cmd("CodeSnapHighlight")
                end,
                mode = "n",
                desc = "Copy snap (highlight, whole buffer)",
            },
            {
                "<leader>cH",
                function()
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
                    vim.cmd("CodeSnapHighlightSave")
                end,
                mode = "v",
                desc = "Save snap (highlight)",
            },
            {
                "<leader>cH",
                function()
                    vim.fn.setpos("'<", { 0, 1, 1, 0 })
                    vim.fn.setpos("'>", { 0, vim.api.nvim_buf_line_count(0), 1, 0 })
                    vim.cmd("CodeSnapHighlightSave")
                end,
                mode = "n",
                desc = "Save snap (highlight, whole buffer)",
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
                    content = "Made by Pxnity",
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
        config = function(_, opts)
            require("codesnap").setup(opts)

            local gen_module = require("codesnap.module")
            local cfg_module = require("codesnap.config")
            local static     = require("codesnap.static")
            local modal      = require("codesnap.modal")


            local function get_config()
                local ok, config = pcall(cfg_module.get_config)
                if not ok or not config then
                    vim.notify("CodeSnap: " .. tostring(config), vim.log.levels.WARN)
                    return nil
                end
                return config
            end

            local function clipboard_cmd(path)
                local is_wayland = vim.env.WAYLAND_DISPLAY ~= nil and vim.env.WAYLAND_DISPLAY ~= ""
                if is_wayland then
                    return "wl-copy --type image/png < " .. vim.fn.shellescape(path)
                else
                    return "xclip -selection clipboard -t image/png -i " .. vim.fn.shellescape(path)
                end
            end

            local function find_gen_lib_path()
                for entry in package.cpath:gmatch("[^;]+") do
                    if entry:match("generator%.so$")
                        or entry:match("generator%.dylib$")
                        or entry:match("generator%.dll$")
                    then
                        return entry
                    end
                end
                return nil
            end

            local function write_config(config, path)
                local f, err = io.open(path, "w")
                if not f then return false, err end
                f:write("return " .. vim.inspect(config))
                f:close()
                return true
            end

            local function gen_async(config, out_path, on_done, on_err)
                gen_module.load_generator()

                local lib_path = find_gen_lib_path()
                if not lib_path then
                    on_err("generator library not found in package.cpath")
                    return
                end

                local cfg_path = "/tmp/codesnap_config.lua"
                local ok, io_err = write_config(config, cfg_path)
                if not ok then
                    on_err("failed to serialise config: " .. tostring(io_err))
                    return
                end

                local work = vim.uv.new_work(
                    function(l_path, c_path, o_path)
                        package.cpath = package.cpath .. ";" .. l_path

                        local r1, gen = pcall(require, "generator")
                        if not r1 then
                            return "load:" .. tostring(gen)
                        end

                        local r2, cfg = pcall(dofile, c_path)
                        if not r2 then
                            return "config:" .. tostring(cfg)
                        end

                        local r3, err = pcall(gen.save, o_path, cfg)
                        if not r3 then
                            return "save:" .. tostring(err)
                        end

                        return ""
                    end,
                    function(result)
                        vim.schedule(function()
                            if result == "" then
                                on_done(out_path)
                            else
                                on_err(result)
                            end
                        end)
                    end
                )

                work:queue(lib_path, cfg_path, out_path)
            end

            local function gen_async_ascii(config, on_done, on_err)
                gen_module.load_generator()

                local lib_path = find_gen_lib_path()
                if not lib_path then
                    on_err("generator library not found in package.cpath")
                    return
                end

                local cfg_path = "/tmp/codesnap_ascii_config.lua"
                local ok, io_err = write_config(config, cfg_path)
                if not ok then
                    on_err("failed to serialise config: " .. tostring(io_err))
                    return
                end

                local work = vim.uv.new_work(
                    function(l_path, c_path)
                        package.cpath = package.cpath .. ";" .. l_path
                        local r1, gen = pcall(require, "generator")
                        if not r1 then return "load:" .. tostring(gen) end
                        local r2, cfg = pcall(dofile, c_path)
                        if not r2 then return "config:" .. tostring(cfg) end
                        local r3, err = pcall(gen.copy_ascii, cfg)
                        if not r3 then return "ascii:" .. tostring(err) end
                        return ""
                    end,
                    function(result)
                        vim.schedule(function()
                            if result == "" then
                                on_done()
                            else
                                on_err(result)
                            end
                        end)
                    end
                )

                work:queue(lib_path, cfg_path)
            end

            local function snap_copy(config)
                local tmp = "/tmp/codesnap_clipboard.png"
                local cmd = clipboard_cmd(tmp)
                vim.notify("CodeSnap: generating…", vim.log.levels.INFO)
                gen_async(
                    config,
                    tmp,
                    function(out)
                        vim.fn.jobstart(cmd, { detach = true })
                        vim.cmd("delmarks <>")
                        vim.notify("Snapshot copied to clipboard", vim.log.levels.INFO)
                    end,
                    function(err)
                        vim.notify("CodeSnap: " .. err, vim.log.levels.ERROR)
                    end
                )
            end

            local function snap_save(config, path)
                local function do_save(p)
                    p = vim.fn.expand(p)
                    vim.notify("CodeSnap: generating…", vim.log.levels.INFO)
                    gen_async(
                        config,
                        p,
                        function(out)
                            vim.cmd("delmarks <>")
                            vim.notify("Snapshot saved to " .. out, vim.log.levels.INFO)
                        end,
                        function(err)
                            vim.notify("CodeSnap: " .. err, vim.log.levels.ERROR)
                        end
                    )
                end

                if path and path ~= "" then
                    do_save(path)
                else
                    local default = vim.fn.expand("~/Pictures/codesnap.png")
                    vim.ui.input({ prompt = "Save snapshot to: ", default = default }, function(p)
                        if not p or p == "" then
                            vim.notify("CodeSnap: save cancelled", vim.log.levels.INFO)
                            return
                        end
                        do_save(p)
                    end)
                end
            end


            pcall(vim.api.nvim_del_user_command, "CodeSnap")
            vim.api.nvim_create_user_command("CodeSnap", function()
                local config = get_config()
                if config then snap_copy(config) end
            end, { range = "%" })

            pcall(vim.api.nvim_del_user_command, "CodeSnapSave")
            vim.api.nvim_create_user_command("CodeSnapSave", function(args)
                local config = get_config()
                if config then snap_save(config, args.args) end
            end, { nargs = "*", range = "%" })

            pcall(vim.api.nvim_del_user_command, "CodeSnapASCII")
            vim.api.nvim_create_user_command("CodeSnapASCII", function()
                local config = get_config()
                if not config then return end
                vim.notify("CodeSnap: generating ASCII…", vim.log.levels.INFO)
                gen_async_ascii(
                    config,
                    function()
                        vim.cmd("delmarks <>")
                        vim.notify("ASCII snapshot copied to clipboard", vim.log.levels.INFO)
                    end,
                    function(err)
                        vim.notify("CodeSnap ASCII: " .. err, vim.log.levels.ERROR)
                    end
                )
            end, { range = "%" })

            pcall(vim.api.nvim_del_user_command, "CodeSnapHighlight")
            vim.api.nvim_create_user_command("CodeSnapHighlight", function()
                local config = get_config()
                if not config then return end
                local text     = config.content.content
                local filetype = vim.bo.filetype

                modal.pop_modal(text, filetype, function(selection)
                    if not selection then
                        vim.notify("CodeSnap: highlight cancelled", vim.log.levels.INFO)
                        return
                    end
                    local lines = vim.split(text, "\n", { plain = true })
                    local s, e  = selection[1], selection[2]
                    if s < 1 or e > #lines or s > e then
                        vim.notify("CodeSnap: invalid selection range", vim.log.levels.ERROR)
                        return
                    end
                    config.content.highlight_lines = { { s, e, static.config.highlight_color } }
                    snap_copy(config)
                end)
            end, { range = "%" })

            pcall(vim.api.nvim_del_user_command, "CodeSnapHighlightSave")
            vim.api.nvim_create_user_command("CodeSnapHighlightSave", function(args)
                local config = get_config()
                if not config then return end
                local text     = config.content.content
                local filetype = vim.bo.filetype

                modal.pop_modal(text, filetype, function(selection)
                    if not selection then
                        vim.notify("CodeSnap: save cancelled", vim.log.levels.INFO)
                        return
                    end
                    local lines = vim.split(text, "\n", { plain = true })
                    local s, e  = selection[1], selection[2]
                    if s < 1 or e > #lines or s > e then
                        vim.notify("CodeSnap: invalid selection range", vim.log.levels.ERROR)
                        return
                    end
                    config.content.highlight_lines = { { s, e, static.config.highlight_color } }
                    snap_save(config, args.args)
                end)
            end, { nargs = "*", range = "%" })
        end,
    },
}
