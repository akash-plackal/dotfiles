vim.g.mapleader = " "

-- commenting
vim.api.nvim_set_keymap("n", "<leader>/", "<plug>NERDCommenterToggle", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader>/", "<plug>NERDCommenterToggle<CR>gv", { noremap = true, silent = true })

-- Save the current file
vim.api.nvim_set_keymap("n", "<leader>w", ":w<CR>", { noremap = true, silent = true })

-- Execute the "send" command on the current file
vim.api.nvim_set_keymap("n", "<leader>sd", ":!send %<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<leader>e", ":Oil<CR>", { noremap = true, silent = true })

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
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")
--
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.api.nvim_set_keymap("n", "[q", ":cprev<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "]q", ":cnext<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "[f", ":bprev<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "]f", ":bnext<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>o", "o<Esc>", { silent = true })
vim.keymap.set("n", "<leader>O", "O<Esc>", { silent = true })
