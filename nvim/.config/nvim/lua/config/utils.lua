-- utils.lua: Utility functions

-- px to rem conversion function
function _G.convertPxToRem()
	local line_number = vim.fn.line(".")
	local line_content = vim.fn.getline(line_number)

	local converted_line = line_content:gsub("(%d+)px", function(pxValue)
		local remValue = tonumber(pxValue) / 16
		return tostring(remValue) .. "rem"
	end)
	vim.fn.setline(line_number, converted_line)
end

-- Add Node.js bin to PATH if using nvm or similar
local function setup_node_path()
	local node_path = vim.fn.system("which node")
	if type(node_path) == "string" and node_path ~= "" then
		local node_bin = node_path:gsub("node\n$", "")
		if node_bin ~= "" then
			vim.env.PATH = node_bin .. ":" .. vim.env.PATH
		end
	end
end

-- Call the setup function
setup_node_path()

-- GitHub Browse keybinding
-- Opens current file in GitHub, with line range support for visual selections

vim.keymap.set("n", "<leader>gh", function()
	local filepath = vim.fn.expand("%")
	local line = vim.fn.line(".")

	if filepath == "" then
		vim.notify("No file in buffer", vim.log.levels.WARN)
		return
	end

	local cmd = string.format("gh browse %s:%d", filepath, line)
	vim.fn.system(cmd)
	vim.notify("Opening in GitHub: " .. filepath .. ":" .. line, vim.log.levels.INFO)
end, { desc = "Open current file in GitHub" })

vim.keymap.set("v", "<leader>gh", function()
	local filepath = vim.fn.expand("%")

	if filepath == "" then
		vim.notify("No file in buffer", vim.log.levels.WARN)
		return
	end

	-- Get the start and end line of visual selection
	local start_line = vim.fn.line("v")
	local end_line = vim.fn.line(".")

	-- Ensure start_line is always less than end_line
	if start_line > end_line then
		start_line, end_line = end_line, start_line
	end

	local cmd = string.format("gh browse %s:%d-%d", filepath, start_line, end_line)
	vim.fn.system(cmd)
	vim.notify("Opening in GitHub: " .. filepath .. ":" .. start_line .. "-" .. end_line, vim.log.levels.INFO)
end, { desc = "Open selected range in GitHub" })
