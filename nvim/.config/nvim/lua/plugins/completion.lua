-- Completion. blink.cmp registers its own LSP capabilities with vim.lsp.config
-- automatically on Neovim 0.11+, so no get_lsp_capabilities() plumbing is needed.
return {
	{
		"Saghen/blink.cmp",
		version = "1.*",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
		},
		opts = {
			snippets = { preset = "luasnip" },

			appearance = { nerd_font_variant = "mono" },

			-- Native Rust matcher with frecency + proximity bonuses,
			-- falling back to the Lua implementation with a warning.
			fuzzy = { implementation = "prefer_rust_with_warning" },

			sources = {
				default = { "snippets", "lsp", "path", "buffer" },
			},

			completion = {
				list = {
					selection = { preselect = true, auto_insert = true },
				},
				accept = {
					auto_brackets = { enabled = true },
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
				},
				ghost_text = { enabled = false }, -- leave the inline lane to supermaven
				menu = {
					draw = {
						columns = {
							{ "label", "label_description", gap = 1 },
							{ "kind_icon", "kind" },
						},
					},
				},
			},

			signature = { enabled = true },

			cmdline = {
				enabled = true,
				keymap = { preset = "cmdline" },
				completion = { menu = { auto_show = true } },
			},

			keymap = {
				preset = "none",
				["<C-n>"] = { "select_next" },
				["<C-p>"] = { "select_prev" },
				["<C-j>"] = { "snippet_forward", "fallback" },
				["<C-k>"] = { "snippet_backward", "fallback" },
				["<C-Space>"] = { "show", "show_documentation" },
				["<C-i>"] = { "accept" },
			},
		},
		opts_extend = { "sources.default" },
	},
	{
		"L3MON4D3/LuaSnip",
		lazy = true,
		build = (vim.fn.executable("make") == 1) and "make install_jsregexp" or nil,
		config = function()
			local ls = require("luasnip")

			ls.setup({
				history = true,
				update_events = { "TextChanged", "TextChangedI" },
			})

			-- Community snippets, plus this config's own Lua snippets
			require("luasnip.loaders.from_vscode").lazy_load()
			require("luasnip.loaders.from_lua").load({
				paths = vim.fn.stdpath("config") .. "/lua/snippets",
			})

			vim.keymap.set({ "i", "s" }, "<C-j>", function()
				ls.jump(1)
			end, { silent = true, desc = "Snippet jump forward" })
			vim.keymap.set({ "i", "s" }, "<C-k>", function()
				ls.jump(-1)
			end, { silent = true, desc = "Snippet jump backward" })
		end,
	},
}
