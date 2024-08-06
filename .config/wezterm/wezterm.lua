local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font_size = 13.0
config.color_scheme = 'Catppuccin Mocha'
config.window_decorations = 'RESIZE'
config.hide_tab_bar_if_only_one_tab = true

config.hyperlink_rules = wezterm.default_hyperlink_rules()

table.insert(config.hyperlink_rules, {
  regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
  format = 'https://www.github.com/$1/$3',
})

return config
