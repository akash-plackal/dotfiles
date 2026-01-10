-- keymaps.lua: Key mappings configuration

vim.g.mapleader = " "

local opts = { noremap = true, silent = true }

-- commenting
vim.api.nvim_set_keymap("n", "<leader>/", "<plug>NERDCommenterToggle", opts)
vim.api.nvim_set_keymap("v", "<leader>/", "<plug>NERDCommenterToggle<CR>gv", opts)

-- File operations
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit window" })
--vim.keymap.set("n", "<leader>x", ":x<CR>", { desc = "Save and quit" })

-- Resize windows with arrows
vim.keymap.set("n", "<C-Up>", ":resize -2<CR>", opts)
vim.keymap.set("n", "<C-Down>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Execute the "send" command on the current file
vim.api.nvim_set_keymap("n", "<leader>sd", ":!send %<CR>", opts)

-- Oil file explorer
vim.api.nvim_set_keymap("n", "<leader>e", ":Oil<CR>", opts)

-- move visual selection
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-f>", "<C-f>zz")
vim.keymap.set("n", "<C-b>", "<C-b>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", [["_dP]])
-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["++y]])
vim.keymap.set("n", "<leader>Y", [["++Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")

-- Undotree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- Search and replace word under cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- px to rem conversion
vim.api.nvim_set_keymap("n", "<leader>rm", [[:lua convertPxToRem()<CR>]], { noremap = true, silent = true })

vim.keymap.set("n", "<Tab>", "<C-^>", {
	desc = "Switch to Alternate Buffer (#)",
	noremap = true,
	silent = true,
})

-- Map H to go to the beginning of the line in Normal, Visual, and Operator-pending modes
vim.keymap.set({ "n", "v", "o" }, "H", "^", { desc = "Go to beginning of line" })

-- Map L to go to the end of the line in Normal, Visual, and Operator-pending modes
vim.keymap.set({ "n", "v", "o" }, "L", "$", { desc = "Go to end of line" })

vim.keymap.set("n", "[f", function()
	require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true })

vim.keymap.set("n", "<leader>qk", ":copen<CR>", { desc = "Open quickfix" })
vim.keymap.set("n", "<leader>qj", ":cclose<CR>", { desc = "Close quickfix" })

vim.keymap.set("n", "<leader>tt", function()
	vim.fn.setqflist({}, "r")

	vim.fn.jobstart({ "npm", "test", "--", "--testLocationInResults" }, {
		stdout_buffered = true,
		stderr_buffered = true,

		on_stdout = function(_, data)
			if not data then
				return
			end

			local lines = {}
			for _, line in ipairs(data) do
				local file, lnum, col = line:match("%((src/.+):(%d+):(%d+)%)")
				if file then
					table.insert(lines, string.format("%s:%s:%s", file, lnum, col))
				end
			end

			if #lines > 0 then
				vim.fn.setqflist({}, "a", {
					efm = "%f:%l:%c",
					lines = lines,
				})
			end
		end,

		on_stderr = function(_, data)
			if not data then
				return
			end

			local lines = {}
			for _, line in ipairs(data) do
				local file, lnum, col = line:match("%((src/.+):(%d+):(%d+)%)")
				if file then
					table.insert(lines, string.format("%s:%s:%s", file, lnum, col))
				end
			end

			if #lines > 0 then
				vim.fn.setqflist({}, "a", {
					efm = "%f:%l:%c",
					lines = lines,
				})
			end
		end,

		on_exit = function()
			if vim.fn.getqflist({ size = 0 }).size > 0 then
				vim.cmd("copen")
				vim.cmd("cfirst")
			else
				print("No test failures 🎉")
			end
		end,
	})
end, { desc = "Run Jest → quickfix (jumpable)" })
