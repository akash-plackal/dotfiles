-- LSP: Neovim 0.11+ native model.
--   * nvim-lspconfig is now only a *data* repository of `lsp/<server>.lua` files.
--   * Servers are configured with vim.lsp.config() and turned on with vim.lsp.enable().
--   * mason-lspconfig v2 calls vim.lsp.enable() for every installed server itself
--     (`automatic_enable`), so there is no setup_handlers() dance any more.
--   * Float borders come from the global 'winborder' option (see config/options.lua),
--     so the old vim.lsp.handlers / open_floating_preview monkey-patching is gone.
return {
	{
		"mason-org/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonUpdate" },
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			ui = { border = "rounded" },
		},
	},

	{
		"mason-org/mason-lspconfig.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {
			ensure_installed = { "jsonls", "eslint", "ts_ls", "cssls", "html", "lua_ls" },
			automatic_enable = true,
		},
	},

	-- mason.nvim only manages LSP servers via mason-lspconfig; formatters and
	-- linters need this to be installed declaratively.
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = {
				"prettierd", -- JS/TS/CSS/HTML/JSON/YAML/Markdown formatting (conform.nvim)
				"stylua", -- Lua formatting (conform.nvim)
			},
			run_on_start = true,
			auto_update = false,
		},
	},

	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			---------------------------------------------------------------------
			-- Server configuration
			---------------------------------------------------------------------

			-- Applies to every server on top of what nvim-lspconfig ships.
			vim.lsp.config("*", {
				capabilities = {
					textDocument = {
						completion = { completionItem = { snippetSupport = true } },
					},
				},
			})

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
			})

			vim.lsp.config("ts_ls", {
				settings = {
					typescript = {
						inlayHints = {
							includeInlayParameterNameHints = "literals",
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = false,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
						},
					},
					javascript = {
						inlayHints = {
							includeInlayParameterNameHints = "literals",
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = false,
						},
					},
				},
			})

			---------------------------------------------------------------------
			-- References picker that skips imports/re-exports and test files
			---------------------------------------------------------------------

			local function filter_references()
				local current_file = vim.fn.expand("%:p")

				local function filtered_references_handler(err, result, ctx)
					if err then
						vim.notify(tostring(err.message), vim.log.levels.ERROR)
						return
					end

					if not result or #result == 0 then
						vim.notify("No references found", vim.log.levels.INFO)
						return
					end

					local filtered_result = {}
					local uri_to_bufnr = {} -- Cache for buffer numbers

					for _, ref in ipairs(result) do
						local uri = ref.uri
						local file_path = vim.uri_to_fname(uri)

						-- 1. INSTANT CHECK: Skip current file
						if file_path == current_file then
							goto continue
						end

						-- 2. INSTANT CHECK: Skip Test/Story files (String matching)
						if
							file_path:find("%.test%.")
							or file_path:find("%.spec%.")
							or file_path:find("%.stories%.")
						then
							goto continue
						end

						local line_num = ref.range.start.line -- 0-indexed for API, 1-indexed for readfile
						local line_content = ""

						-- 3. MEMORY OPTIMIZATION: Check if buffer is loaded
						local bufnr = uri_to_bufnr[uri]
						if not bufnr then
							bufnr = vim.fn.bufnr(file_path)
							uri_to_bufnr[uri] = bufnr
						end

						if bufnr ~= -1 and vim.api.nvim_buf_is_loaded(bufnr) then
							-- Read from Memory (Instant)
							local lines = vim.api.nvim_buf_get_lines(bufnr, line_num, line_num + 1, false)
							if lines and lines[1] then
								line_content = lines[1]
							else
								goto continue
							end
						else
							-- Read from Disk (Only if absolutely necessary)
							local lines = vim.fn.readfile(file_path, "", line_num + 1)
							if lines and lines[line_num + 1] then
								line_content = lines[line_num + 1]
							else
								goto continue
							end
						end

						-- 4. STRING OPTIMIZATION: Trim and check first word
						local s = line_content:match("^%s*(.*)") -- trim leading whitespace
						if not s or s == "" then
							goto continue
						end

						if s:sub(1, 6) == "import" or s:sub(1, 4) == "from" or s:sub(1, 6) == "export" then
							goto continue
						end

						table.insert(filtered_result, ref)
						::continue::
					end

					if #filtered_result == 0 then
						vim.notify("No references found (after filtering)", vim.log.levels.INFO)
						return
					end

					local client = vim.lsp.get_client_by_id(ctx.client_id)
					local items =
						vim.lsp.util.locations_to_items(filtered_result, client and client.offset_encoding or "utf-16")

					vim.fn.setqflist({}, " ", {
						title = "LSP References (Optimized)",
						items = items,
					})
					vim.cmd("copen")
				end

				local clients = vim.lsp.get_clients({ bufnr = 0 })
				local encoding = (clients and clients[1]) and clients[1].offset_encoding or "utf-16"
				local params = vim.lsp.util.make_position_params(0, encoding)

				params.context = { includeDeclaration = true }
				vim.lsp.buf_request(0, "textDocument/references", params, filtered_references_handler)
			end

			---------------------------------------------------------------------
			-- Buffer-local setup, driven by LspAttach (works with automatic_enable)
			---------------------------------------------------------------------

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
				callback = function(ev)
					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					if not client then
						return
					end

					local bufopts = function(desc)
						return { noremap = true, silent = true, buffer = ev.buf, desc = desc }
					end

					-- Neovim already maps grn/gra/grr/gri/grt/gO/K/<C-s>; these are the extras.
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts("Go to declaration"))
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts("Go to definition"))
					vim.keymap.set("n", "gk", vim.lsp.buf.hover, bufopts("Hover"))
					vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, bufopts("Signature help"))
					vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts("Type definition"))
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts("Code action"))
					vim.keymap.set("n", "gi", filter_references, bufopts("References (filtered)"))

					vim.keymap.set("n", "<leader>fm", function()
						vim.lsp.buf.format({ async = true })
					end, bufopts("Format buffer"))

					vim.keymap.set("n", "<leader>cx", function()
						vim.lsp.buf.code_action({
							context = { only = { "quickfix" }, diagnostics = vim.diagnostic.get(0) },
							apply = false,
						})
					end, bufopts("Quickfix code action"))

					-- Organize imports. vim.lsp.buf.execute_command() is deprecated;
					-- the LSP-standard way is the source.organizeImports code action.
					vim.keymap.set("n", "<leader>oi", function()
						vim.lsp.buf.code_action({
							context = { only = { "source.organizeImports" }, diagnostics = {} },
							apply = true,
						})
					end, bufopts("Organize imports"))

					-- References to this module's default export
					vim.keymap.set("n", "go", function()
						local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
						local target_line = 0

						for i = #lines, 1, -1 do
							if lines[i]:match("export%s+default") then
								target_line = i
								break
							end
						end

						if target_line == 0 then
							for i, line in ipairs(lines) do
								if line:match("^export") then
									target_line = i
									break
								end
							end
						end

						local saved_pos = vim.api.nvim_win_get_cursor(0)
						if target_line ~= 0 then
							vim.api.nvim_win_set_cursor(0, { target_line, 0 })
						end
						filter_references()
						vim.api.nvim_win_set_cursor(0, saved_pos)
					end, bufopts("References to default export"))

					-- NOTE: vim.lsp.foldexpr() (0.11+) is deliberately NOT enabled here --
					-- it would clobber the custom import-folding foldexpr that
					-- lua/plugins/ui.lua installs for JS/TS buffers.

					-- 0.11+: inlay hints, off by default, toggled with <leader>th
					if client:supports_method("textDocument/inlayHint") then
						vim.keymap.set("n", "<leader>th", function()
							local filter = { bufnr = ev.buf }
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(filter), filter)
						end, bufopts("Toggle inlay hints"))
					end

					-- 0.12: rename all occurrences of a tag/symbol as you type
					if client:supports_method("textDocument/linkedEditingRange") then
						vim.lsp.linked_editing_range.enable(true, { bufnr = ev.buf })
					end
				end,
			})
		end,
	},
}
