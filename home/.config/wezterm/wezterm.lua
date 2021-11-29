local wezterm = require 'wezterm';
-- cursor theme: xfconf-query --channel xsettings --property /Gtk/CursorThemeName --set Adwaita
return {
  color_scheme = "Gruvbox Dark",
  hide_tab_bar_if_only_one_tab = true,
  font = wezterm.font("FantasqueSansMono Nerd Font"),
  font_size = 14.0,
  set_environment_variables = {
      TMUX_ALWAYS = "true",
      THEME_ENABLE_GLYPHS = "1",
  },
}

