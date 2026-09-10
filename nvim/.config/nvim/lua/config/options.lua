-- options.lua: Vim options and settings

-- Disable unused providers (avoids startup cost + checkhealth noise)
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0 -- only used by Node *remote plugins* (rplugin)

-- Disable builtin plugins we don't use.
-- NOTE: gzip/tar/zip/tohtml/tutor are disabled in lua/config/lazy.lua instead;
-- keep this list to the ones lazy.nvim's rtp filter doesn't cover.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1

-- Editor defaults
vim.o.number = true
vim.o.relativenumber = true
vim.o.smartindent = true
vim.o.swapfile = false
vim.o.backup = false
vim.o.undofile = true
vim.o.undodir = vim.fs.joinpath(vim.uv.os_homedir(), ".vim", "undodir")
vim.o.incsearch = true
vim.o.hlsearch = false
vim.o.scrolloff = 8
vim.o.sidescrolloff = 8
vim.o.updatetime = 50
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.wrap = true
vim.o.termguicolors = true
vim.o.signcolumn = "yes"
vim.opt.isfname:append("@-@")

-- Modern UX defaults (0.10+ / 0.11+)
vim.o.winborder = "rounded" -- default border for ALL floats (LSP hover, diagnostics, ...)
vim.o.inccommand = "split" -- live preview of :s, with an off-screen result split
vim.o.smoothscroll = true -- scroll by screen line, not buffer line, when wrapping
vim.o.splitkeep = "screen" -- don't shift text when opening/closing splits
vim.o.confirm = true -- prompt instead of failing on :q with unsaved changes
vim.o.pumheight = 12 -- cap the completion popup height
vim.o.pummaxwidth = 60 -- cap the completion popup width (0.12)
vim.o.jumpoptions = "stack,view" -- browser-like jumplist, restore the view on jump

-- Tab settings
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smarttab = true

-- Split behavior
vim.o.splitbelow = true
vim.o.splitright = true

-- Diff options.
-- 0.12 already defaults to "internal,filler,closeoff,inline:char,linematch:40,
-- indent-heuristic" so only the algorithm choice is worth overriding.
vim.opt.diffopt:append("algorithm:histogram")
vim.opt.diffopt:append("inline:word")

-- Diagnostics: inline virtual text on every line, cursor line included.
-- `virtual_lines` (the below-the-line renderer) is off; <leader>dl toggles it
-- on demand for messages too long to read inline.
vim.diagnostic.config({
	severity_sort = true,
	underline = { severity = { min = vim.diagnostic.severity.HINT } },
	virtual_text = {
		-- NOTE: omit `current_line` entirely. `false` would mean "show on all
		-- lines EXCEPT the cursor line"; nil means "show on all lines".
		source = "if_many",
		spacing = 2,
		prefix = "●",
	},
	virtual_lines = false,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚 ",
			[vim.diagnostic.severity.WARN] = "󰀪 ",
			[vim.diagnostic.severity.INFO] = "󰋽 ",
			[vim.diagnostic.severity.HINT] = "󰌶 ",
		},
	},
	jump = { float = true }, -- ]d / [d open the diagnostic float on landing
})

-- Colorscheme is configured by mini.hues (lua/plugins/ui.lua)

-- Custom highlights
vim.api.nvim_set_hl(0, "DiffText", { fg = "#ffffff", bg = "#1d3b40" })
vim.api.nvim_set_hl(0, "BiscuitColor", { fg = "#cc241d" })
