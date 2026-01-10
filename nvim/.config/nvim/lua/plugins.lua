-- plugins.lua - Lazy plugin manager configuration
return {
	-- Core plugins

	{ "folke/lazy.nvim", tag = "stable" },

	{ "nvim-lua/plenary.nvim" },

	{ "ellisonleao/gruvbox.nvim" },
	{
		"stevearc/conform.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					javascript = { "prettierd", "prettier", stop_after_first = true },
					-- Add entries for TypeScript, TSX, and JSX
					typescript = { "prettierd", "prettier", stop_after_first = true },
					typescriptreact = { "prettierd", "prettier", stop_after_first = true }, -- For .tsx files
					javascriptreact = { "prettierd", "prettier", stop_after_first = true }, -- For .jsx files
					json = { "prettierd", "prettier" },
					css = { "prettierd", "prettier" },
					scss = { "prettierd", "prettier" },
					html = { "prettierd", "prettier" },
					markdown = { "prettierd", "prettier" },
					yaml = { "prettierd", "prettier" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
			})

			-- Optional: If you want format on save using an autocmd
			-- local conform_augroups = vim.api.nvim_create_augroup("ConformFormatting", { clear = true })
			-- vim.api.nvim_create_autocmd("BufWritePre", {
			--   pattern = "*",
			--   group = conform_augroups,
			--   callback = function(args)
			--     require("conform").format({ bufnr = args.buf, timeout_ms = 500 })
			--   end,
			-- })
		end,
	},
	-- using packer.nvim
	{
		"nmac427/guess-indent.nvim",
		config = function()
			require("guess-indent").setup({})
		end,
	},

	{
		"stevearc/oil.nvim",
		config = function()
			require("oil").setup()
		end,
	},
	{
		"mbbill/undotree",
		cmd = "UndotreeToggle", -- Only load when command is used
	},

	-- Editing tools - load on specific events
	{
		"preservim/nerdcommenter",
		event = { "BufReadPost", "BufNewFile" },
	},
	--{
	--"windwp/nvim-autopairs",
	--event = "InsertEnter",
	--config = function()
	--require("nvim-autopairs").setup({})
	--end,
	--},

	-- AI assistance
	{
		"supermaven-inc/supermaven-nvim",
		event = "InsertEnter",
		config = function()
			require("supermaven-nvim").setup({
				keymaps = {
					accept_word = "<C-h>",
					accept_suggestion = "<C-l>",
					clear_suggestion = "<C-]>",
				},
				log_level = "off",
				disable_keymaps = false,
			})
		end,
	},

	{
		"nvim-orgmode/orgmode",
		ft = "org",
		config = function()
			require("orgmode").setup({
				org_agenda_files = "~/orgfiles/**/*",
				org_default_notes_file = "~/orgfiles/refile.org",
			})
		end,
	},

	-- HTTP Client
	--[[{
		"mistweaverco/kulala.nvim",
		keys = {
			{
				"<leader>x",
				function()
					require("kulala").run()
				end,
				desc = "Send request",
			},
			{
				"<leader>pd",
				function()
					require("kulala").scratchpad()
				end,
				desc = "Open scratchpad",
			},
		},
		ft = { "http", "rest" },
		env_file_names = { "http-client.env.json", "kulala-env.json" },
		opts = {
			global_keymaps = true,
		},
	},]]
}
