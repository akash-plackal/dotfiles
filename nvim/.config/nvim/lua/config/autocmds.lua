-- autocmds.lua: Autocommands configuration

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 150 })
	end,
})

-- Auto save all buffers on focus lost
vim.api.nvim_create_autocmd("FocusLost", {
	pattern = "*",
	callback = function()
		-- Save all modified buffers
		vim.cmd("silent! wall")

		if pcall(require, "conform") then
			require("conform").format()
		end
	end,
})

-- Clear command line messages after 1 second
vim.api.nvim_create_autocmd("BufWritePost", {
	callback = function()
		vim.defer_fn(function()
			vim.cmd('echon ""')
		end, 850)
	end,
})

vim.api.nvim_create_autocmd("UIEnter", {
	callback = function()
		vim.o.clipboard = "unnamedplus"
	end,
})
