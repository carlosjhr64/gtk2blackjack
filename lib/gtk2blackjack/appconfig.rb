module Gtk2AppLib
module Configuration
  BACKGROUND_COLOR = Color[/hooker.*green/i]
  OPTIONS	= {
	:modify_font	=> FONT[:Small],
	:modify_fg	=> [Gtk::STATE_NORMAL, Color[/white/i]],
	:modify_bg	=> [Gtk::STATE_NORMAL, BACKGROUND_COLOR],
  }
  MENU[:fs] = '_Fullscreen' if HILDON
end
end
