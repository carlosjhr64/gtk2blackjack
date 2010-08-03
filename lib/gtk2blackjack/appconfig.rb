module Gtk2AppLib
module Configuration
  BACKGROUND_COLOR = COLOR[:green]
  OPTIONS	= {
	:font		=> FONT[:small],
	:label_fg	=> {Gtk::STATE_NORMAL => COLOR[:white]},
	:image_bg	=> {Gtk::STATE_NORMAL => BACKGROUND_COLOR},
  }
  MENU[:fs] = '_Fullscreen' if Gtk2AppLib::WRAPPER.to_s == 'HildonWrapper'
end
end
