-- autocmds.lua: Autocommands configuration

local augroup = function(name)
	return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

-- Highlight yanked text (vim.highlight was renamed to vim.hl in 0.11)
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		vim.hl.on_yank({ higroup = "Visual", timeout = 150 })
	end,
})

-- Auto save (and format) all buffers on focus lost
vim.api.nvim_create_autocmd("FocusLost", {
	group = augroup("autosave"),
	pattern = "*",
	callback = function()
		vim.cmd("silent! wall")

		local ok, conform = pcall(require, "conform")
		if ok then
			conform.format()
		end
	end,
})

-- Clear command line messages shortly after a write
vim.api.nvim_create_autocmd("BufWritePost", {
	group = augroup("clear_cmdline"),
	callback = function()
		vim.defer_fn(function()
			vim.cmd('echon ""')
		end, 850)
	end,
})

vim.api.nvim_create_autocmd("UIEnter", {
	group = augroup("clipboard"),
	callback = function()
		vim.o.clipboard = "unnamedplus"
	end,
})

-- Restore the last cursor position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup("last_loc"),
	callback = function(ev)
		if vim.bo[ev.buf].filetype == "gitcommit" or vim.b[ev.buf].last_loc_restored then
			return
		end
		vim.b[ev.buf].last_loc_restored = true

		local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(ev.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Auto-create missing parent directories on write
vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup("auto_mkdir"),
	callback = function(ev)
		if ev.match:match("^%w%w+://") then
			return
		end
		vim.fn.mkdir(vim.fs.dirname(vim.uv.fs_realpath(ev.match) or ev.match), "p")
	end,
})

-- Close scratch-ish windows with plain `q`
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("close_with_q"),
	pattern = { "help", "qf", "checkhealth", "man", "lspinfo", "query", "undotree" },
	callback = function(ev)
		vim.bo[ev.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = ev.buf, silent = true })
	end,
})
