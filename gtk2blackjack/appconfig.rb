module Configuration
  CANVAS_IMAGE_DIRECTORY = UserSpace::DIRECTORY+'/pngs/'
  BACKGROUND_COLOR = COLOR[:green]
  WIDGET_OPTIONS[:font] = FONT[:small]
  WIDGET_OPTIONS[:label_fg] = {Gtk::STATE_NORMAL => COLOR[:white]}
  WIDGET_OPTIONS[:image_bg] = {Gtk::STATE_NORMAL => BACKGROUND_COLOR}
  MENU[:fs] = '_Fullscreen' if Gtk2App::HILDON
end
