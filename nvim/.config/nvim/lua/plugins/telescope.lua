-- Telescope and related plugins
return {
	-- Telescope with lazy loading
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		cmd = "Telescope", -- Only load when Telescope command is used
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")

			telescope.setup({
				defaults = {
					-- Better file ignore patterns
					file_ignore_patterns = {
						"node_modules",
						".git/",
						"dist/",
						"build/",
						"*.lock",
					},
					-- Better layout and preview
					layout_config = {
						horizontal = {
							preview_width = 0.6,
						},
						vertical = {
							preview_height = 0.6,
						},
					},
					-- Better sorting and matching
					sorting_strategy = "ascending",
					layout_strategy = "horizontal",
					winblend = 0,
					border = {},
					borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
					color_devicons = true,
					use_less = true,
					path_display = { "smart" },
					set_env = { ["COLORTERM"] = "truecolor" },
				},
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
				pickers = {
					find_files = {
						hidden = true,
						find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
					},
					live_grep = {
						additional_args = function(opts)
							if
								opts.search
								and (opts.search:match("%s") or opts.search:match("[%(%)%[%]%{%}%*%+%-%?%^%$%.]"))
							then
								return { "--fixed-strings" }
							else
								return {}
							end
						end,
						-- Better grep options
						glob_pattern = "!{.git/*,node_modules/*,dist/*,build/*}",
					},
					buffers = {
						show_all_buffers = true,
						sort_lastused = true,
						theme = "dropdown",
						previewer = false,
						mappings = {
							i = {
								["<c-d>"] = "delete_buffer",
							},
						},
					},
					git_files = {
						show_untracked = true,
					},
				},
			})

			-- Load extensions
			telescope.load_extension("fzf")

			-- Custom function for grepping quickfix files
			local function grep_quickfix_files()
				local qf_list = vim.fn.getqflist()
				local files = {}
				for _, item in ipairs(qf_list) do -- Fixed: was qf*list
					local bufnr = item.bufnr
					local fname = vim.fn.bufname(bufnr)
					if fname and fname ~= "" then
						files[fname] = true
					end
				end
				local file_list = vim.tbl_keys(files)
				if #file_list == 0 then
					vim.notify("No files in quickfix list", vim.log.levels.WARN)
					return
				end
				builtin.live_grep({
					search_dirs = file_list,
					prompt_title = "Grep Quickfix Files",
				})
			end

			-- Define common themes
			local themes = require("telescope.themes")
			local dropdown_theme = themes.get_dropdown({
				previewer = false,
				width = 0.6,
				height = 0.6,
			})
			local ivy_theme = themes.get_ivy({
				path_display = { "smart" },
			})
			local cursor_theme = themes.get_cursor({
				path_display = { "smart" },
			})

			-- Keymaps with better organization and descriptions
			local keymap = vim.keymap.set
			local opts = { noremap = true, silent = true }

			-- File operations
			keymap("n", "<leader>fd", function()
				builtin.fd(dropdown_theme)
			end, vim.tbl_extend("force", opts, { desc = "Find Files (fd)" }))

			keymap("n", "<leader>fp", function()
				builtin.find_files(ivy_theme)
			end, vim.tbl_extend("force", opts, { desc = "Find Files (Project)" }))

			keymap("n", "<leader>fo", function()
				builtin.oldfiles(ivy_theme)
			end, vim.tbl_extend("force", opts, { desc = "Find Old Files" }))

			-- Search operations
			keymap("n", "<leader>fg", function()
				builtin.live_grep(ivy_theme)
			end, vim.tbl_extend("force", opts, { desc = "Live Grep" }))

			keymap("n", "<leader>fw", function()
				builtin.grep_string(ivy_theme)
			end, vim.tbl_extend("force", opts, { desc = "Grep Word Under Cursor" }))

			keymap(
				"n",
				"<leader>gq",
				grep_quickfix_files,
				vim.tbl_extend("force", opts, { desc = "Grep Quickfix Files" })
			)

			-- Git operations

			keymap("n", "<leader>fh", function()
				builtin.git_status(ivy_theme)
			end, vim.tbl_extend("force", opts, { desc = "Git Status" }))

			keymap("n", "<leader>gb", function()
				builtin.git_branches(ivy_theme)
			end, vim.tbl_extend("force", opts, { desc = "Git Branches" }))

			-- LSP operations
			keymap("n", "<leader>fs", function()
				builtin.lsp_document_symbols(cursor_theme)
			end, vim.tbl_extend("force", opts, { desc = "LSP Document Symbols" }))

			-- Telescope meta operations
			keymap("n", "<leader>fe", function()
				builtin.resume(ivy_theme)
			end, vim.tbl_extend("force", opts, { desc = "Resume Last Telescope" }))
		end,
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
		dependencies = { "nvim-telescope/telescope.nvim" },
		config = function()
			-- Ensure fzf extension is loaded after telescope setup
			require("telescope").load_extension("fzf")
		end,
	},
}
