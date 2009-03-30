module Configuration
  RANK = '2 3 4 5 6 7 8 9 x j q k a'.split(/\s+/)
  SUIT = 'c d h s'.split(/\s+/)
  CANVAS_IMAGE_DIRECTORY = UserSpace::DIRECTORY+'/pngs/'
  # CANVAS_IMAGE_DIRECTORY/RANKSUIT.png
  CANVAS_IMAGE_PATTERN = /\/(\w+)\.png$/
  COLOR[:bg] = COLOR[:darkgreen]
  COLOR[:fg] = COLOR[:white]
end
