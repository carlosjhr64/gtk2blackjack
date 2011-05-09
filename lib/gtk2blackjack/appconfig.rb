module Gtk2AppLib
module Configuration
  MENU[:fs] = '_Fullscreen' if HILDON
end
end

module Gtk2BlackJack
module Configuration
  BACKGROUND_COLOR = Gtk2AppLib::Color[/hooker.*green/i]
  OPTIONS	= {
	:modify_font	=> Gtk2AppLib::Configuration::FONT[:SMALL],
	:modify_fg	=> [Gtk::STATE_NORMAL, Gtk2AppLib::Color[/white/i]],
	:modify_bg	=> [Gtk::STATE_NORMAL, BACKGROUND_COLOR],
  }
end
end
