-- harpoon v1 (master) is retired; all maintenance happens on the harpoon2 branch.
return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		event = "VeryLazy",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup() -- required in v2: it registers the autocmds

			vim.keymap.set("n", "<leader>a", function()
				harpoon:list():add()
			end, { desc = "Harpoon add file" })

			vim.keymap.set("n", "<leader>hi", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, { desc = "Harpoon menu" })

			for i, key in ipairs({ "j", "k", "l", ";" }) do
				vim.keymap.set("n", "<leader>" .. key, function()
					harpoon:list():select(i)
				end, { desc = "Harpoon file " .. i })
			end

			vim.keymap.set("n", "<leader>hn", function()
				harpoon:list():next()
			end, { desc = "Harpoon next" })
			vim.keymap.set("n", "<leader>hN", function()
				harpoon:list():prev()
			end, { desc = "Harpoon previous" })
		end,
	},
}
