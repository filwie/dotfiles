local wezterm = require 'wezterm';
-- cursor theme: xfconf-query --channel xsettings --property /Gtk/CursorThemeName --set Adwaita
return {
  color_scheme = "Gruvbox Dark",
  hide_tab_bar_if_only_one_tab = true,
  font = wezterm.font("Fantasque Sans Mono"),
  font_size = 13.0,
  set_environment_variables = {
      THEME_ENABLE_GLYPHS = "1",
      TMUX_ALWAYS = "true",
      LINEGLYPH = ""
  },
}

