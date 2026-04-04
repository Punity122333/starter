
return {
	"saghen/blink.cmp",
	opts = function(_, opts)
		-- Shared context reader: returns (has_existing_args, has_empty_parens)
		-- given the text currently in the buffer at/after the cursor.
		local function paren_context()
			local col = vim.fn.col(".")
			local line = vim.api.nvim_get_current_line()
			-- From the cursor column onward.  col() is 1-indexed bytes, same as sub().
			local rest = line:sub(col)
			-- Skip any trailing identifier chars that blink will also replace
			-- (cursor may be on e.g. the 'l' in 'del', so rest = 'l("i", ...)')
			local word_tail = rest:match("^[%w_%.]*") or ""
			local after = rest:sub(#word_tail + 1)
			local inside = after:match("^%((.-)%)")  -- content inside first ()
			if inside == nil then
				return false, false
			end
			local has_args = inside:match("%S") ~= nil
			return has_args, not has_args  -- (existing_args, empty_parens)
		end

		-- Wraps cmp.accept() to remove the leftover `()` when the snippet was
		-- inserted into already-empty parens: del()|  →  del(mode, lhs…)()  →  del(mode, lhs…)
		local function smart_accept(cmp)
			if not cmp.is_visible() then return false end
			local _, empty = paren_context()
			local ok = cmp.accept()
			if ok and empty then
				vim.schedule(function()
					local cur_line = vim.api.nvim_get_current_line()
					-- Pattern: snippet closed its paren, then the original () follows
					local fixed = cur_line
						:gsub("%)%(%)$", ")")               -- at end of line
						:gsub("%)%(%)([^%w%(])", ")" .. "%1") -- mid-line
					if fixed ~= cur_line then
						local cursor = vim.api.nvim_win_get_cursor(0)
						vim.api.nvim_set_current_line(fixed)
						-- keep cursor inside snippet; clamp if line got shorter
						local max_col = math.max(0, #fixed - 1)
						if cursor[2] > max_col then
							vim.api.nvim_win_set_cursor(0, { cursor[1], max_col })
						end
					end
				end)
			end
			return ok
		end

		return vim.tbl_deep_extend("force", opts or {}, {
			enabled = function()
				return vim.b.blink_enabled ~= false and vim.bo.buftype ~= "prompt"
			end,
			snippets = {
				preset = "luasnip",
				-- Intercept snippet expansion at accept-time (the only reliable hook).
				-- At this point blink has already deleted the typed word; the cursor
				-- sits right where the snippet would be inserted.
				expand = function(snippet)
					local ls = require("luasnip")
					local col  = vim.fn.col(".")
					local line = vim.api.nvim_get_current_line()
					-- text from the cursor position onward
					local rest = line:sub(col)
					-- skip any word chars that weren't deleted (safety for edge cases)
					local word_tail = rest:match("^[%w_%.]*") or ""
					local after     = rest:sub(#word_tail + 1)
					local inside    = after:match("^%((.-)%)")

					local has_real_args   = inside ~= nil and inside:match("%S") ~= nil
					local has_empty_paren = inside ~= nil and not inside:match("%S")

					if has_real_args then
						-- Existing args present: just insert the bare name, skip the template.
						-- e.g. fn|("i", x)  →  fn("i", x)
						local name = snippet:match("^([%w_%.]+)") or snippet
						local row, c = unpack(vim.api.nvim_win_get_cursor(0))
						vim.api.nvim_buf_set_text(0, row - 1, c, row - 1, c, { name })
						vim.api.nvim_win_set_cursor(0, { row, c + #name })
					elseif has_empty_paren then
						-- Empty parens present: expand normally so tabstops fill them in,
						-- then remove the now-redundant () that follows.
						-- e.g. fn|()  →  fn(mode, lhs…)
						ls.lsp_expand(snippet)
						vim.schedule(function()
							local cl = vim.api.nvim_get_current_line()
							local fixed = cl
								:gsub("%)%(%)$", ")")
								:gsub("%)%(%)([^%w%(])", function(ch) return ")" .. ch end)
							if fixed ~= cl then
								vim.api.nvim_set_current_line(fixed)
							end
						end)
					else
						ls.lsp_expand(snippet)
					end
				end,
			},
			completion = {
				list = {
					selection = { preselect = true, auto_insert = false },
				},
				ghost_text = { enabled = false },
				trigger = {
					show_on_keyword = true,
					show_on_trigger_character = true,
				},
				accept = {
					auto_brackets = { enabled = true },
					resolve_timeout_ms = 1500,
					dot_repeat = false,
				},
				menu = {
					auto_show = true,
					border = "rounded",
					scrollbar = false,
					winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
				},
				documentation = {
					auto_show = true,
					window = {
						scrollbar = false,
						border = "rounded",
						winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine",
					},
				},
			},
			signature = { enabled = false },
			fuzzy = {
				implementation = "lua",
			},
			keymap = {
				preset = "default",
				["<Up>"] = { "fallback" },
				["<Down>"] = { "fallback" },
				["<C-n>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback" },
				["<C-Up>"] = { "select_prev", "fallback" },
				["<C-Down>"] = { "select_next", "fallback" },
				["<S-CR>"] = { smart_accept, "fallback" },
				["<C-y>"] = { smart_accept, "fallback" },
				["<C-j>"] = { "select_next", "fallback" },
				["<C-k>"] = { "select_prev", "fallback" },
				["<C-CR>"] = { smart_accept, "fallback" },
				["<C-S-0>"] = {
					function()
						vim.lsp.buf.signature_help()
						return true
					end,
					"fallback",
				},
				["<C-]>"] = {
					function()
						vim.lsp.buf.signature_help()
						return true
					end,
					"fallback",
				},
				["<Tab>"] = {
					function(cmp)
						local copilot_ok, copilot = pcall(require, "copilot.suggestion")
						if copilot_ok and copilot.is_visible() then
							copilot.accept()
							return true
						end

						-- 2. Use LuaSnip for jumping instead of vim.snippet
						local luasnip = require("luasnip")
						if luasnip.expand_or_jumpable() then
							return luasnip.expand_or_jump()
						end

						if cmp.is_visible() then
							return cmp.accept()
						end

						local col = vim.fn.col(".") - 1
						local line = vim.api.nvim_get_current_line()
						if col == 0 or line:sub(col, col):match("%s") then
							return false
						end
					end,
					"snippet_forward",
					"fallback",
				},
				-- 3. Update S-Tab for LuaSnip backward jumping
				["<S-Tab>"] = {
					function()
						local luasnip = require("luasnip")
						if luasnip.jumpable(-1) then
							return luasnip.jump(-1)
						end
					end,
					"snippet_backward",
					"fallback",
				},
			},
			sources = {
				-- 4. Add "snippets" to the default list
				default = { "lsp", "path", "snippets", "buffer" },
				providers = {
					lsp = {
						name = "lsp",
						enabled = true,
						module = "blink.cmp.sources.lsp",
						max_items = 25,
						timeout_ms = 1000,
					},
					buffer = { max_items = 25 },
					path = { max_items = 25 },
					snippets = {
						name = "snippets",
						enabled = true,
						max_items = 8,
						min_keyword_length = 2,
						module = "blink.cmp.sources.snippets",
					},
				},
			},
		})
	end,
}


