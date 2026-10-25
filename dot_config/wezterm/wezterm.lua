local wezterm = require 'wezterm'
local mux = wezterm.mux
local config = {}

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local title = tab.tab_index + 1 .. ': ' .. tab.active_pane.title

  return {
    { Text = ' ' .. title .. ' ' },
  }
end)

config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
config.color_scheme = 'nord'
config.font = wezterm.font 'UDEV Gothic NF'
config.font_size = 12.0

config.keys = {
  {
    key = 'd',
    mods = 'ALT',
    action = wezterm.action.SplitHorizontal {
      domain = 'CurrentPaneDomain',
    },
  },
  {
    key = 'D',
    mods = 'ALT|SHIFT',
    action = wezterm.action.SplitVertical {
     domain = 'CurrentPaneDomain',
    },
  },
}

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  config.default_prog = { 'wsl.exe', '~' }
elseif wezterm.target_triple == 'aarch64-apple-darwin' then
  config.font_size = 16.0
end

return config
