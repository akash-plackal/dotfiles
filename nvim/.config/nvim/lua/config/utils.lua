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

-- GitHub Browse keybinding
-- Opens current file in GitHub, with line range support for visual selections

local function gh_browse(start_line, end_line)
	local filepath = vim.fn.expand("%")
	if filepath == "" then
		vim.notify("No file in buffer", vim.log.levels.WARN)
		return
	end

	local target = end_line and string.format("%s:%d-%d", filepath, start_line, end_line)
		or string.format("%s:%d", filepath, start_line)

	vim.system({ "gh", "browse", target }, { text = true }, function(res)
		vim.schedule(function()
			if res.code ~= 0 then
				vim.notify("gh browse failed: " .. (res.stderr or ""), vim.log.levels.ERROR)
			else
				vim.notify("Opening in GitHub: " .. target, vim.log.levels.INFO)
			end
		end)
	end)
end

vim.keymap.set("n", "<leader>gh", function()
	gh_browse(vim.fn.line("."))
end, { desc = "Open current file in GitHub" })

vim.keymap.set("v", "<leader>gh", function()
	local start_line, end_line = vim.fn.line("v"), vim.fn.line(".")
	if start_line > end_line then
		start_line, end_line = end_line, start_line
	end
	gh_browse(start_line, end_line)
end, { desc = "Open selected range in GitHub" })
