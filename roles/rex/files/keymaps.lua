-- Pass alt+arrow through to the terminal for word movement.
rex.unbind("alt+left")
rex.unbind("alt+right")

-- [[ Tmux-style keybindings ]]
-- Ctrl+J is the prefix.

-- Tabs
rex.bind("ctrl+j>c", "client.tab.new")
rex.bind("ctrl+j>n", "client.tab.next")
rex.bind("ctrl+j>p", "client.tab.previous")
rex.bind("ctrl+j>ctrl+n", "client.tab.next")
rex.bind("ctrl+j>ctrl+p", "client.tab.previous")
rex.bind("ctrl+j>,", "client.tab.rename")
rex.bind("ctrl+j>shift+7", "client.tab.close") -- &
rex.bind("ctrl+j>shift+,", "client.tab.move.backward") -- <
rex.bind("ctrl+j>shift+.", "client.tab.move.forward") -- >

for index = 1, 8 do
    rex.bind("ctrl+j>" .. index, "client.tab.goto", { index = index })
end

-- Sessions
rex.bind("ctrl+j>s", "session.switch")
rex.bind("ctrl+j>shift+c", "session.new")
rex.bind("ctrl+j>shift+x", "session.close")
rex.bind("ctrl+j>shift+4", "session.rename") -- $
rex.bind("ctrl+j>shift+9", "session.previous") -- (
rex.bind("ctrl+j>shift+0", "session.next") -- )

-- Panes
rex.bind("ctrl+j>x", "pane.close")
rex.bind("ctrl+j>\\", "pane.split", { direction = "right" })
rex.bind("ctrl+j>-", "pane.split", { direction = "down" })
rex.bind("ctrl+j>h", "pane.focus", { direction = "left" })
rex.bind("ctrl+j>j", "pane.focus", { direction = "down" })
rex.bind("ctrl+j>k", "pane.focus", { direction = "up" })
rex.bind("ctrl+j>l", "pane.focus", { direction = "right" })
rex.bind("ctrl+j>o", "pane.focus_next")
rex.bind("ctrl+j>;", "pane.focus_previous")
rex.bind("ctrl+j>shift+[", "pane.move", { direction = "left" }) -- {
rex.bind("ctrl+j>shift+]", "pane.move", { direction = "right" }) -- }
rex.bind("ctrl+j>shift+1", "pane.move_to_new_tab") -- !
rex.bind("ctrl+j>shift+f", "pane.float")
rex.bind("ctrl+j>=", "pane.balance")
rex.bind("ctrl+j>z", "pane.zoom")

-- Rex
rex.bind("ctrl+j>/", "client.find.open")
rex.bind("ctrl+j>b", "client.sidebar.toggle")
rex.bind("ctrl+j>a", "client.sidebar.activity.toggle")
rex.bind("ctrl+j>shift+r", "client.config.reload")
rex.bind("ctrl+j>shift+s", "client.settings")
rex.bind("ctrl+j>shift+;", "client.palette.toggle") -- :

-- Press Ctrl+J twice to send Ctrl+J to the focused terminal.
rex.bind("ctrl+j>ctrl+j", "pane.send_key", { key = "ctrl+j" })

-- Custom actions
local home = os.getenv("HOME")
rex.bind("ctrl+j>f", "session_launcher")
rex.bind("ctrl+j>shift+g", "open_github")
rex.bind("ctrl+j>shift+h", "quick_session", { path = home .. "/Developer/dotfiles" })
rex.bind("ctrl+j>shift+j", "quick_session", { path = home .. "/Developer/tmp" })
rex.bind("ctrl+j>shift+k", "quick_session", { path = home .. "/Developer/x" })

-- Copy mode
rex.bind("ctrl+j>[", "copy_mode")

-- [[ Resize mode ]]
-- See: https://www.superlogical.com/rex/docs/customize/key-modes
-- Ctrl+J R enters the mode; Enter or Escape leaves it.
rex.mode("resize", { exclusive = true })
rex.bind("ctrl+j>r", "client.mode.enter", { name = "resize" })

rex.bind("resize/left", "pane.resize", { direction = "left" })
rex.bind("resize/right", "pane.resize", { direction = "right" })
rex.bind("resize/up", "pane.resize", { direction = "up" })
rex.bind("resize/down", "pane.resize", { direction = "down" })

-- Hold Shift for bigger horizontal steps.
rex.bind("resize/shift+left", "pane.resize", {
    direction = "left",
    amount = 15,
})
rex.bind("resize/shift+right", "pane.resize", {
    direction = "right",
    amount = 15,
})

rex.bind("resize/=", "pane.balance")
rex.bind("resize/enter", "client.mode.exit")
