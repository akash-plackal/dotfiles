-- Completion plugin configuration
return {
	{
		"Saghen/blink.cmp",
		version = "1.*",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"L3MON4D3/LuaSnip",
		},
		config = function()
			require("blink.cmp").setup({
				sources = {
					providers = {
						snippets = { name = "snippets", opts = { preset = "luasnip" } },
						lsp = { name = "lsp" },
						path = { name = "path" },
						buffer = { name = "buffer" },
					},
					default = { "snippets", "lsp", "path", "buffer" },
				},
				enabled = function()
					return true
				end,
				completion = {
					list = {
						selection = {
							preselect = true,
							auto_insert = true,
						},
					},
					accept = {
						auto_brackets = {
							enabled = true,
						},
					},
					menu = {
						draw = {
							columns = {
								{ "label", "label_description", gap = 1 },
								{ "kind_icon", "kind" },
							},
						},
					},
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
			})
		end,
	},
	{
		"L3MON4D3/LuaSnip",
		config = function()
			local ls = require("luasnip")

			ls.setup({
				history = true,
				update_events = { "TextChanged", "TextChangedI" },
			})

			require("luasnip.loaders.from_lua").load({ paths = vim.fn.expand("~/.config/nvim/lua/snippets") })
			vim.keymap.set({ "i", "s" }, "<C-j>", function()
				ls.jump(1)
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<C-k>", function()
				ls.jump(-1)
			end, { silent = true })
		end,
	},
}
