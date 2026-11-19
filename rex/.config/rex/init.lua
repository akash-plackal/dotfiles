-- Converted tmux keybindings

-- Rex has no global prefix setting; represent tmux's C-a prefix as a key sequence.
local prefix = "ctrl+a>"

-- Prefix + split panes
-- Prefix + | (press Shift+Backslash).
rex.bind(prefix .. "shift+\\", "pane.split", {
	direction = "right",
})
rex.bind(prefix .. "-", "pane.split", {
	direction = "down",
})

-- Common tmux default bindings
rex.bind(prefix .. "c", "client.tab.new")
rex.bind(prefix .. "n", "client.tab.next")
rex.bind(prefix .. "p", "client.tab.previous")
rex.bind(prefix .. "o", "pane.focus_next")
rex.bind(prefix .. ";", "pane.focus_previous")
rex.bind(prefix .. "x", "pane.close")
rex.bind(prefix .. "z", "pane.zoom")
rex.bind(prefix .. "s", "session.switch")
rex.bind(prefix .. ",", "client.tab.rename")
rex.bind(prefix .. "shift+7", "client.tab.close") -- &
rex.bind(prefix .. "shift+[", "pane.move", { direction = "left" }) -- {
rex.bind(prefix .. "shift+]", "pane.move", { direction = "right" }) -- }
rex.bind(prefix .. "shift+1", "pane.move_to_new_tab") -- !
rex.bind(prefix .. "[", "pane.copy_mode.enter")
rex.bind(prefix .. "]", "pane.paste")

-- With base-index 1, Ctrl+A followed by 1-9 selects tabs 1-9.
for i = 1, 9 do
	rex.bind(prefix .. tostring(i), "client.tab.goto", { index = i })
end

-- Prefix + Vim-style pane navigation
rex.bind(prefix .. "h", "pane.focus", { direction = "left" })
rex.bind(prefix .. "j", "pane.focus", { direction = "down" })
rex.bind(prefix .. "k", "pane.focus", { direction = "up" })
rex.bind(prefix .. "l", "pane.focus", { direction = "right" })

-- Prefix + reload Rex config
rex.bind(prefix .. "r", "client.config.reload")

-- Prefix + C-o: open a larger floating pane (80% of the window).
rex.action{
	name = "new_large_floating",
	title = "New Large Floating Pane",
	run = function(ctx)
		local result, err = rex.session.new_layer{
			session_id = ctx.session_id,
			bounds = { 0.1, 0.1, 0.8, 0.8 },
			focus = true,
			layout = rex.layout.block{
				flavor = "com.superlogical.terminal.shell",
			},
		}
		if not result then
			error(err)
		end
		return result
	end,
}
rex.bind(prefix .. "ctrl+o", "new_large_floating")

-- Prefix twice sends C-a to the shell
rex.bind(prefix .. "ctrl+a", "pane.send_key", {
	key = "ctrl+a",
})
