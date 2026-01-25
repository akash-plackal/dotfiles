-- Neovim configuration

-- Set leader key early
vim.g.mapleader = " "
vim.g.maplocalleader = " "

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
