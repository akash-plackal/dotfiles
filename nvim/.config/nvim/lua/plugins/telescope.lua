-- Telescope and related plugins

-- Themes are built lazily: get_dropdown/get_ivy/get_cursor need telescope on
-- the runtimepath, which is only true once lazy.nvim has loaded the plugin.
local function picker(name, theme, theme_opts)
	return function()
		local themes = require("telescope.themes")
		require("telescope.builtin")[name](themes["get_" .. theme](theme_opts or { path_display = { "smart" } }))
	end
end

-- Live-grep restricted to the files currently in the quickfix list.
local function grep_quickfix_files()
	local files = {}
	for _, item in ipairs(vim.fn.getqflist()) do
		local fname = vim.fn.bufname(item.bufnr)
		if fname and fname ~= "" then
			files[fname] = true
		end
	end

	local file_list = vim.tbl_keys(files)
	if #file_list == 0 then
		vim.notify("No files in quickfix list", vim.log.levels.WARN)
		return
	end

	require("telescope.builtin").live_grep({
		search_dirs = file_list,
		prompt_title = "Grep Quickfix Files",
	})
end

return {
	-- Telescope with lazy loading
	{
		"nvim-telescope/telescope.nvim",
		branch = "master",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-fzf-native.nvim",
		},
		-- These MUST live in `keys`, not in config(). Defining them inside
		-- config() means they only exist after telescope has already loaded,
		-- and nothing else pulls telescope in -- so they would never fire.
		-- lazy.nvim installs a stub for each and loads telescope on first press.
		keys = {
			-- Files
			{
				"<leader>fd",
				picker("find_files", "dropdown", { previewer = false, width = 0.6, height = 0.6 }),
				desc = "Find Files (dropdown)",
			},
			{ "<leader>fp", picker("find_files", "ivy"), desc = "Find Files (Project)" },
			{ "<leader>fo", picker("oldfiles", "ivy"), desc = "Find Old Files" },
			-- Search
			{ "<leader>fg", picker("live_grep", "ivy"), desc = "Live Grep" },
			{ "<leader>fw", picker("grep_string", "ivy"), desc = "Grep Word Under Cursor" },
			{ "<leader>gq", grep_quickfix_files, desc = "Grep Quickfix Files" },
			-- Git
			{ "<leader>fh", picker("git_status", "ivy"), desc = "Git Status" },
			{ "<leader>gb", picker("git_branches", "ivy"), desc = "Git Branches" },
			-- LSP
			{ "<leader>fs", picker("lsp_document_symbols", "cursor"), desc = "LSP Document Symbols" },
			-- Meta
			{ "<leader>fe", picker("resume", "ivy"), desc = "Resume Last Telescope" },
		},
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
					borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
					color_devicons = true,
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
		end,
	},
	{
		-- Native fzf sorter. Loaded as a telescope dependency so that
		-- telescope.load_extension("fzf") above always finds it.
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
		lazy = true,
	},
}
