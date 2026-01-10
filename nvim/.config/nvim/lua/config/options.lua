-- options.lua: Vim options and settings

---- Performance optimizations
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1

-- Editor defaults
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.smartindent = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.updatetime = 50
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrap = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- Tab settings
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smarttab = true

-- Split behavior
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Command-line completion settings
--vim.opt.wildmode = "longest:full,full"
--vim.opt.wildmenu = true
--vim.opt.wildignore:append({ "*.o", "*.obj", "*.bin", "node_modules/*", ".git/*" })

-- Better diff options
vim.opt.diffopt:append("algorithm:patience")
vim.opt.diffopt:append("indent-heuristic")

-- Set colorscheme
vim.cmd.colorscheme("gruvbox")

-- Custom highlights
vim.api.nvim_set_hl(0, "DiffText", { fg = "#ffffff", bg = "#1d3b40" })

--vim.api.nvim_set_hl(0, "BiscuitColor", { fg = "#00FFFF", ctermfg = "cyan" })
vim.api.nvim_set_hl(0, "BiscuitColor", { fg = "#cc241d" })
--vim.api.nvim_set_hl(0, "BiscuitColorTypescript", { fg = "#FF0000", ctermfg = "red" })
