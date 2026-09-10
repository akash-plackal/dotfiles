-- plugins.lua - Lazy plugin manager configuration
--
-- Removed as redundant with Neovim builtins:
--   preservim/nerdcommenter -> builtin `gc` / `gcc` operator (:h gc-default)
--   mbbill/undotree         -> builtin `:Undotree` (0.12, :packadd nvim.undotree)
return {
	-- Core plugins

	{ "folke/lazy.nvim", tag = "stable" },

	{
		"stevearc/conform.nvim",
		event = { "BufReadPost", "BufNewFile" },
		cmd = "ConformInfo",
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "prettierd", "prettier", stop_after_first = true }, -- .tsx
				javascriptreact = { "prettierd", "prettier", stop_after_first = true }, -- .jsx
				json = { "prettierd", "prettier", stop_after_first = true },
				jsonc = { "prettierd", "prettier", stop_after_first = true },
				css = { "prettierd", "prettier", stop_after_first = true },
				scss = { "prettierd", "prettier", stop_after_first = true },
				html = { "prettierd", "prettier", stop_after_first = true },
				markdown = { "prettierd", "prettier", stop_after_first = true },
				yaml = { "prettierd", "prettier", stop_after_first = true },
				graphql = { "prettierd", "prettier", stop_after_first = true },
			},
			-- `lsp_fallback` was replaced by the more explicit `lsp_format`.
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback",
			},
		},
	},

	{
		"nmac427/guess-indent.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {},
	},

	{
		"stevearc/oil.nvim",
		lazy = false, -- must own the netrw hijack before the first buffer opens
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			default_file_explorer = true,
			view_options = { show_hidden = true },
			keymaps = {
				["<C-h>"] = false, -- leave <C-h> to supermaven's accept_word
			},
		},
	},

	-- Keymap discovery. Surfaces the whole <leader> tree while you type it,
	-- which is worth a lot in a config with this many leader mappings.
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "helix",
			spec = {
				{ "<leader>f", group = "find" },
				{ "<leader>g", group = "git" },
				{ "<leader>h", group = "hunks / harpoon" },
				{ "<leader>c", group = "code" },
				{ "<leader>q", group = "quickfix" },
				{ "<leader>t", group = "toggle" },
			},
		},
	},

	-- Project-wide find & replace with a live preview buffer. Complements
	-- <leader>s, which only rewrites the current file.
	{
		"MagicDuck/grug-far.nvim",
		cmd = "GrugFar",
		opts = { headerMaxWidth = 80 },
		keys = {
			{
				"<leader>S",
				function()
					require("grug-far").open({ transient = true })
				end,
				mode = { "n", "v" },
				desc = "Search & replace in project",
			},
		},
	},

	-- Auto-close and auto-rename JSX/HTML tags via treesitter
	{
		"windwp/nvim-ts-autotag",
		ft = { "html", "javascriptreact", "typescriptreact", "svelte", "vue", "xml", "markdown" },
		opts = {},
	},

	-- AI assistance
	{
		"supermaven-inc/supermaven-nvim",
		event = "InsertEnter",
		opts = {
			keymaps = {
				accept_word = "<C-h>",
				accept_suggestion = "<C-l>",
				clear_suggestion = "<C-]>",
			},
			log_level = "off",
			disable_keymaps = false,
		},
	},

	{
		"nvim-orgmode/orgmode",
		ft = "org",
		opts = {
			org_agenda_files = "~/orgfiles/**/*",
			org_default_notes_file = "~/orgfiles/refile.org",
		},
	},
}
