local M = {}

local EMPTY = "%#SignColumn#  "
local _ns_cache = {}
local _enabled = false

local TRACKED = {
    dap_breakpoints = true,
    MarkSigns = true,
    gitsigns_signs_ = true,
}

local function get_ns(name)
    if not _ns_cache[name] then
        local id = vim.api.nvim_get_namespaces()[name]
        if id then
            _ns_cache[name] = id
        end
    end
    return _ns_cache[name]
end

local function extmark_sign(ns_name, buf, lnum)
    local ns = get_ns(ns_name)
    if not ns then
        return EMPTY
    end

    local ok, ems = pcall(
        vim.api.nvim_buf_get_extmarks,
        buf,
        ns,
        { lnum - 1, 0 },
        { lnum - 1, -1 },
        { details = true }
    )

    if ok and ems[1] then
        local d = ems[1][4]
        if d and d.sign_text and d.sign_text ~= "" then
            return "%#" .. (d.sign_hl_group or "SignColumn") .. "#" .. d.sign_text
        end
    end

    return EMPTY
end

local function diag_sign(buf, lnum)
    local diags = vim.diagnostic.get(buf, { lnum = lnum - 1 })
    if #diags == 0 then
        return EMPTY
    end

    local sev = diags[1].severity
    for _, d in ipairs(diags) do
        if d.severity < sev then
            sev = d.severity
        end
    end

    local sev_name = ({
        [vim.diagnostic.severity.ERROR] = "Error",
        [vim.diagnostic.severity.WARN] = "Warn",
        [vim.diagnostic.severity.INFO] = "Info",
        [vim.diagnostic.severity.HINT] = "Hint",
    })[sev]

    if not sev_name then
        return EMPTY
    end

    local def = vim.fn.sign_getdefined("DiagnosticSign" .. sev_name)[1]
    local txt = (def and def.text) or (sev_name:sub(1, 1) .. " ")
    return "%#DiagnosticSign" .. sev_name .. "#" .. txt
end

local function make_number(buf, lnum)
    local num = (vim.wo.relativenumber and vim.v.relnum ~= 0) and vim.v.relnum or lnum
    local num_hl = vim.v.relnum == 0 and "%#CursorLineNr#" or "%#LineNr#"
    local width = math.max(#tostring(vim.api.nvim_buf_line_count(buf)), 2)
    return num_hl .. " " .. string.format("%" .. width .. "d", num) .. " "
end

_G.StatusColumn = function()
    local buf = vim.api.nvim_get_current_buf()
    local lnum = vim.v.lnum
    return extmark_sign("dap_breakpoints", buf, lnum)
        .. diag_sign(buf, lnum)
        .. extmark_sign("MarkSigns", buf, lnum)
        .. make_number(buf, lnum)
        .. extmark_sign("gitsigns_signs_", buf, lnum)
end

_G.StatusColumnSimple = function()
    local buf = vim.api.nvim_get_current_buf()
    local lnum = vim.v.lnum
    local sign_col = EMPTY
    local best_p = -1

    for ns_name in pairs(TRACKED) do
        if ns_name ~= "gitsigns_signs_" then
            local ns = get_ns(ns_name)
            if ns then
                local ok, ems = pcall(
                    vim.api.nvim_buf_get_extmarks,
                    buf,
                    ns,
                    { lnum - 1, 0 },
                    { lnum - 1, -1 },
                    { details = true }
                )
                if ok then
                    for _, em in ipairs(ems) do
                        local d = em[4]
                        if d and d.sign_text and d.sign_text ~= "" and (d.priority or 0) > best_p then
                            best_p = d.priority or 0
                            sign_col = "%#" .. (d.sign_hl_group or "SignColumn") .. "#" .. d.sign_text
                        end
                    end
                end
            end
        end
    end

    return sign_col .. make_number(buf, lnum) .. extmark_sign("gitsigns_signs_", buf, lnum)
end

local function apply()
    local ft = vim.bo.filetype
    local bt = vim.bo.buftype

    local exclude = {
        "NvimTree",
        "neo-tree",
        "oil",
        "stevearc.oil",
        "lazy",
        "mason",
        "trouble",
        "dashboard",
        "alpha",
        "snacks_dashboard",
        "starter",
        "help",
        "man",
        "checkhealth",
        "tutor",
        "dapui_scopes",
        "dapui_breakpoints",
        "dapui_stacks",
        "dapui_watches",
        "dapui_console",
        "dap-repl",
        "dap-terminal",
        "avante",
        "avante-input",
        "avante-selected",
        "avante-chat",
        "Avante",
        "notify",
        "noice",
        "snacks_notif",
        "snacks_notif_history",
        "snacks_win_backdrop",
        "TelescopePrompt",
        "TelescopeResults",
        "qf",
        "gitcommit",
        "git",
        "diff",
        "toggleterm",
        "undotree",
    }

    if bt == "nofile" or bt == "prompt" then
        if ft:find("dap") then
            if ft:find("float") then
                vim.opt_local.statuscolumn = ""
                vim.opt_local.number = false
                vim.opt_local.relativenumber = false
                return
            else
                vim.opt_local.statuscolumn = "   "
                vim.opt_local.number = false
                vim.opt_local.relativenumber = false
                return
            end
        else
            vim.opt_local.statuscolumn = ""
            vim.opt_local.number = false
            vim.opt_local.relativenumber = false
            return
        end
    end

    if ft:find("Avante") then
        vim.opt_local.statuscolumn = ""
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        table.insert(exclude, ft)
        return
    end

    if ft:find("^snacks_") then
        table.insert(exclude, ft)
        return
    end

    if ft:find("dap") then
        vim.opt_local.statuscolumn = "   "
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        return
    end

    if vim.tbl_contains(exclude, ft) or ft:find("avante") or bt == "nofile" or bt == "prompt" then
        vim.opt_local.statuscolumn = " "
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        return
    end

    vim.opt.signcolumn = "no"
    vim.opt.statuscolumn = _enabled and "%{%v:lua.StatusColumn()%}" or "%{%v:lua.StatusColumnSimple()%}"

    vim.opt_local.number = true
    vim.opt_local.relativenumber = true
end

function M.setup()
    apply()

    vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
        callback = apply,
    })

    vim.keymap.set("n", "<leader>Us", function()
        _enabled = not _enabled
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local cfg = vim.api.nvim_win_get_config(win)
            if cfg.relative == "" then
                vim.api.nvim_win_call(win, apply)
            end
        end
        vim.notify(
            _enabled and "Custom signcolumn enabled" or "Simple signcolumn enabled",
            vim.log.levels.INFO,
            { title = "UI Toggle" }
        )
    end, { desc = "Toggle signcolumn (all windows)" })
end

return M
