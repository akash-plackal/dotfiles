-- keymaps.lua: Key mappings configuration
--
-- Neovim ships a lot of these now; see :h default-mappings and :h lsp-defaults.
-- Notably already built in, so NOT redefined here:
--   gc / gcc           comment operator / comment line
--   [q ]q [b ]b [d ]d  unimpaired-style quickfix / buffer / diagnostic motions
--   grn gra grr gri grt gO   LSP rename / code action / references / impl / type / symbols
--   K                  LSP hover      i_CTRL-S  LSP signature help
--   :Undotree          undo tree viewer (0.12)

local opts = { noremap = true, silent = true }

-- Commenting: <leader>/ on top of the builtin gc operator.
-- `remap = true` is required because gcc/gc are themselves mappings.
vim.keymap.set("n", "<leader>/", "gcc", { remap = true, desc = "Toggle comment line" })
vim.keymap.set("x", "<leader>/", "gc", { remap = true, desc = "Toggle comment selection" })

-- File operations
vim.keymap.set("n", "<leader>w", "<cmd>write<CR>", { desc = "Save file" })
-- NOTE: no <leader>q mapping. It is the prefix for <leader>qk / <leader>qj, and
-- binding it to :quit as well made Vim wait 'timeoutlen' and then close the
-- window on any hesitation. Use :q / ZZ / ZQ to quit.

-- Resize windows with arrows
vim.keymap.set("n", "<C-Up>", "<cmd>resize -2<CR>", opts)
vim.keymap.set("n", "<C-Down>", "<cmd>resize +2<CR>", opts)
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>", opts)
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>", opts)

-- Execute the "send" command on the current file
vim.keymap.set("n", "<leader>sd", "<cmd>!send %<CR>", { desc = "send current file" })

-- Oil file explorer
vim.keymap.set("n", "<leader>e", "<cmd>Oil<CR>", { desc = "Open parent directory (Oil)" })

-- Move visual selection
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep the cursor put / centered
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-f>", "<C-f>zz")
vim.keymap.set("n", "<C-b>", "<C-b>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Registers
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without clobbering register" })
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to black hole" })

vim.keymap.set("n", "Q", "<nop>")

-- Quickfix
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz", { desc = "Next quickfix item" })
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz", { desc = "Previous quickfix item" })
vim.keymap.set("n", "<leader>qk", "<cmd>copen<CR>", { desc = "Open quickfix" })
vim.keymap.set("n", "<leader>qj", "<cmd>cclose<CR>", { desc = "Close quickfix" })

-- Undo tree (builtin since 0.12; mbbill/undotree is no longer needed).
-- The builtin plugin ships opt-in, so :packadd it on first use.
vim.keymap.set("n", "<leader>u", function()
	vim.cmd.packadd("nvim.undotree")
	require("undotree").open()
end, { desc = "Toggle undo tree" })

-- Search and replace word under cursor ('inccommand' previews this live)
vim.keymap.set(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Replace word under cursor" }
)

-- px to rem conversion
vim.keymap.set("n", "<leader>rm", function()
	convertPxToRem()
end, { desc = "Convert px to rem on this line" })

-- Diagnostics
vim.keymap.set("n", "ge", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
vim.keymap.set("n", "<leader>fq", function()
	vim.diagnostic.setqflist({ title = "All Diagnostics" })
end, { desc = "All diagnostics to quickfix" })
-- virtual_lines is off by default (see config/options.lua). Toggle it on when a
-- message is too long to read inline; virtual_text swaps out while it is on.
-- Lives under <leader>t (toggle), NOT <leader>d -- <leader>d is the black-hole
-- delete operator, so <leader>dl would swallow the `l` motion.
vim.keymap.set("n", "<leader>tl", function()
	local on = vim.diagnostic.config().virtual_lines ~= false
	vim.diagnostic.config({
		virtual_lines = not on,
		virtual_text = on and { source = "if_many", spacing = 2, prefix = "●" } or false,
	})
	vim.notify("Diagnostic virtual lines " .. (on and "off" or "on"))
end, { desc = "Toggle diagnostic virtual lines" })

vim.keymap.set("n", "<Tab>", "<C-^>", { desc = "Switch to alternate buffer (#)", noremap = true, silent = true })

-- H / L to line start / end
vim.keymap.set({ "n", "v", "o" }, "H", "^", { desc = "Go to beginning of line" })
vim.keymap.set({ "n", "v", "o" }, "L", "$", { desc = "Go to end of line" })

-- Jump to the enclosing treesitter context
vim.keymap.set("n", "[f", function()
	require("treesitter-context").go_to_context(vim.v.count1)
end, { silent = true, desc = "Jump to context" })
