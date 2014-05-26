require 'gosu_enhanced'

module Crossword
  # Constants for the crossword game
  module Constants
    include GosuEnhanced

    MARGIN      = 5

    GRID_ORIGIN = Point.new( MARGIN * 2, MARGIN * 2 )

    CELL_SIZE   = Size.new( 28, 28 )

    CLUE_COLUMN_WIDTH = 290

    BASE_WIDTH  = MARGIN * 8 + 2 * CLUE_COLUMN_WIDTH
    BASE_HEIGHT = MARGIN * 4

    WHITE       = Gosu::Color.new( 0xffffffff )
    BLACK       = Gosu::Color.new( 0xff000000 )
    HIGHLIGHT   = Gosu::Color.new( 0xffe8ffff )   # Liquid Cyan
    CURRENT     = Gosu::Color.new( 0xffa8ffff )   # Less Liquid Cyan
    CLUE_LIGHT  = Gosu::Color.new( 0xff009090 )   # Dark Cyan
    ERROR_BK    = Gosu::Color.new( 0xffffe0e0 )   # Liquid Pink
    ERROR_FG    = Gosu::Color.new( 0xffff0000 )   # Bold Red
    
    BK_COLOURS  = { none:     WHITE, 
                    word:     HIGHLIGHT, 
                    current:  CURRENT, 
                    wrong:    ERROR_BK }
  end
end
