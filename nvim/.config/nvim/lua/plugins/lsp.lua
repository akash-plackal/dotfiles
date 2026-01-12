return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			-- Configure LSP borders
			local border = "single"
			-- Configure border colors/background (Gruvbox Dark)
			vim.api.nvim_set_hl(0, "FloatBorder", {
				fg = "#665c54", -- gruvbox gray (border color)
				bg = "#3c3836", -- gruvbox bg1 (background color)
			})
			vim.api.nvim_set_hl(0, "NormalFloat", {
				bg = "#3c3836", -- gruvbox bg1 (floating window background)
			})

			-- Configure LSP handlers with borders
			local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
			function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
				opts = opts or {}
				opts.border = opts.border or border
				return orig_util_open_floating_preview(contents, syntax, opts, ...)
			end
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = border,
			})
			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
				border = border,
			})
			-- Configure diagnostic float with borders
			vim.diagnostic.config({
				float = {
					border = border,
				},
			})

			-- LSP Mappings + Settings
			local opts = { noremap = true, silent = true }
			vim.keymap.set("n", "<space>d", vim.diagnostic.open_float, opts)
			vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

			-- Function to filter references
			local function filter_references()
				local current_file = vim.fn.expand("%:p")

				local function filtered_references_handler(err, result, ctx, config)
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

						-- Check starts with "import"
						if s:sub(1, 6) == "import" then
							goto continue
						end

						-- Check starts with "from"
						if s:sub(1, 4) == "from" then
							goto continue
						end

						-- Check starts with "export"
						if s:sub(1, 6) == "export" then
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

			local on_attach = function(client, bufnr)
				vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
				local bufopts = { noremap = true, silent = true, buffer = bufnr }
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
				vim.keymap.set("n", "gk", vim.lsp.buf.hover, bufopts)
				vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, bufopts)
				vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
				vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
				vim.keymap.set("n", "ge", vim.diagnostic.open_float, bufopts)
				-- Use filtered references instead of default
				vim.keymap.set("n", "gi", filter_references, bufopts)
				vim.keymap.set("n", "<space>fm", function()
					vim.lsp.buf.format({ async = true })
				end, bufopts)
				vim.keymap.set("n", "<space>oi", function()
					vim.lsp.buf.execute_command({
						command = "_typescript.organizeImports",
						arguments = { vim.fn.expand("%:p") },
					})
				end, bufopts)
				vim.keymap.set("n", "<space>fq", function()
					vim.diagnostic.setqflist({
						title = "All Diagnostics",
						severity = nil,
					})
				end, bufopts)
				vim.keymap.set("n", "<space>cx", function()
					vim.lsp.buf.code_action({
						context = {
							only = { "quickfix" },
							diagnostics = vim.diagnostic.get(0),
						},
						apply = false,
					})
				end, bufopts)

				vim.keymap.set("n", "go", function()
					-- Find the default export from the end of the file
					local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
					local target_line = 0

					-- Search from the end for "export default"
					for i = #lines, 1, -1 do
						if lines[i]:match("export%s+default") then
							target_line = i
							break
						end
					end

					-- Fallback: if no default export found, search from top for any export
					if target_line == 0 then
						for i, line in ipairs(lines) do
							if line:match("^export") then
								target_line = i
								break
							end
						end
					end

					-- Save current position
					local saved_pos = vim.api.nvim_win_get_cursor(0)

					-- Jump to the export line (if found)
					if target_line ~= 0 then
						vim.api.nvim_win_set_cursor(0, { target_line, 0 })
					end

					-- Call your existing filtered references function
					filter_references()

					-- Restore cursor position
					vim.api.nvim_win_set_cursor(0, saved_pos)
				end, bufopts)
			end

			-- Use existing capabilities:
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			-- === NEW: define & enable servers via vim.lsp.config / vim.lsp.enable ===
			-- Common server options to merge
			local common_opts = {
				on_attach = on_attach,
				capabilities = capabilities,
			}

			-- helper to merge and register a server config then enable it
			local function register_and_enable(name, cfg)
				cfg = vim.tbl_deep_extend("force", common_opts, cfg or {})
				-- define the server config
				-- you can use either assignment or function-call API; both work:
				vim.lsp.config[name] = cfg
				-- enable the server (activation for matching filetypes)
				vim.lsp.enable(name)
			end

			-- Servers with the same/basic config
			local servers = { "jsonls", "eslint" }
			for _, name in ipairs(servers) do
				register_and_enable(name, {})
			end

			register_and_enable("ts_ls", {
				cmd = { "typescript-language-server", "--stdio" },
			})

			-- Servers with explicit/extra config
			register_and_enable("cssls", {
				-- add cssls specifics here if you want (cmd, filetypes, settings, etc)
			})

			register_and_enable("html", {
				-- add html specifics here if you want
			})

			-- End of LSP setup
		end,
	},
}
