-- lazy.lua: Lazy.nvim bootstrap and configuration

local M = {}

function M.setup()
	-- Bootstrap lazy.nvim
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not vim.uv.fs_stat(lazypath) then
		local out = vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable", -- latest stable release
			lazypath,
		})
		if vim.v.shell_error ~= 0 then
			error("Failed to clone lazy.nvim:\n" .. out)
		end
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
					"netrwPlugin",
					"matchit",
					"matchparen",
					"rplugin",
					"spellfile",
				},
			},
		},
		change_detection = {
			notify = false, -- Don't show notifications when plugin files change
		},
		checker = {
			enabled = true, -- Check for plugin updates in the background
			notify = false,
		},
		ui = {
			border = "rounded", -- Add rounded borders to the Lazy UI
		},
	})
end

return M
