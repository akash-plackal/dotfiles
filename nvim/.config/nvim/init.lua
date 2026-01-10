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
