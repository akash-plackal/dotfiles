-- lazy.lua: Lazy.nvim bootstrap and configuration

local M = {}

function M.setup()
	-- Bootstrap lazy.nvim
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable", -- latest stable release
			lazypath,
		})
	end
	vim.opt.rtp:prepend(lazypath)

	-- Initialize lazy.nvim
	require("lazy").setup({
		spec = {
			{ import = "plugins" },
		},
		rocks = {
			enabled = false, -- Disable luarocks support
		},
		performance = {
			rtp = {
				disabled_plugins = {
					"gzip",
					"tarPlugin",
					"tohtml",
					"tutor",
					"zipPlugin",
				},
			},
		},
		change_detection = {
			notify = false, -- Don't show notifications when plugin files change
		},
		ui = {
			border = "rounded", -- Add rounded borders to the Lazy UI
		},
	})
end

return M
