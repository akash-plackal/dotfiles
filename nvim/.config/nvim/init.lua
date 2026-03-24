-- Neovim configuration

-- Set leader key early
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Keep the site dir in runtimepath/packpath without a trailing slash.
-- nvim-treesitter health checks compare against stdpath("data") .. "/site"
-- and can report a false negative when the config appends "/site/".
local data_site = vim.fn.stdpath("data") .. "/site"
vim.opt.runtimepath:append(data_site)
vim.opt.packpath:append(data_site)

-- Load Lazy.nvim bootstrap and setup
require("config.lazy").setup()

-- Load core configurations
require("config.options") -- Editor options
require("config.keymaps") -- Key mappings
require("config.autocmds") -- Auto commands
require("config.utils") -- Utility functions


local node_bin = vim.fn.expand("~/.nvm/versions/node/v24.12.0/bin")

if vim.fn.isdirectory(node_bin) == 1 then
  vim.env.PATH = node_bin .. ":" .. vim.env.PATH
end
