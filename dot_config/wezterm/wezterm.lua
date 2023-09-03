local wezterm = require 'wezterm'
local mux = wezterm.mux
local config = {}

wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local title = tab.tab_index + 1 .. ': ' .. tab.active_pane.title

  return {
    { Text = ' ' .. title .. ' ' },
  }
end)

config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
config.color_scheme = 'nord'
config.font = wezterm.font 'MesloLGS NF'
config.font_size = 12.0

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  config.default_prog = { 'wsl.exe', '~' }
end

return config
