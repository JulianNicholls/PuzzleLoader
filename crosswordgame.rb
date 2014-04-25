#! /usr/bin/env ruby

require 'gosu_enhanced'

require './constants'
require './resources'
require './puzloader'
require './crosswordgrid'

module Crossword
  # Crossword!
  class Game < Gosu::Window
    include Constants

    def initialize( grid )
      @grid   = grid
      @width  = BASE_WIDTH + grid.width * CELL_SIZE.width
      @height = BASE_HEIGHT + grid.height * CELL_SIZE.height

      @down_left    = @width - (MARGIN * 2 + CLUE_COLUMN_WIDTH)
      @across_left  = @down_left - (MARGIN * 2 + CLUE_COLUMN_WIDTH)

      super( @width, @height, false, 100 )

      self.caption = 'Crosswords'

      @font = ResourceLoader.fonts( self )
    end

    def needs_cursor?
      true
    end

    def update
    end

    def draw
      draw_background
      draw_grid
      draw_clues
    end

    def button_down( btn_id )
      close if btn_id == Gosu::KbEscape
    end

    private

    def draw_background
      origin = Point.new( 0, 0 )
      size   = Size.new( @width, @height )
      draw_rectangle( origin, size, 0, WHITE )

      origin.move_by!( MARGIN, MARGIN )
      size.deflate!( MARGIN * 2, MARGIN * 2 )
      draw_rectangle( origin, size, 0, BLACK )
    end

    def draw_grid
      @grid.height.times do |row|
        pos = GRID_ORIGIN.offset( 0, row * CELL_SIZE.height )

        @grid.width.times do |col|
          draw_rectangle( pos, CELL_SIZE, 1, BLACK )
          cell = @grid.cell_at( row, col )
          draw_cell( pos.dup, cell ) unless cell.blank?

          pos.move_by!( CELL_SIZE.width, 0 )
        end
      end
    end

    def draw_clues
      across_point = Point.new( @across_left, MARGIN * 2 )
      down_point   = Point.new( @down_left, MARGIN * 2 )

      draw_clue_list( across_point, 'Across', @grid.across_clues )
      draw_clue_list( down_point, 'Down', @grid.down_clues )
    end

    def draw_clue_list( pos, header, list )
      @font[:header].draw( header, pos.x, pos.y, 1, 1, 1, WHITE )

      pos.move_by!( 0, (@font[:header].height * 7) / 6 )

      font = @font[:clue]

      list.each do |clue|
        text = clue.text
        size = font.measure( text )

        font.draw( clue.number, pos.x, pos.y, 1, 1, 1, WHITE )

        if size.width > CLUE_COLUMN_WIDTH
          wrap( text, (size.width / CLUE_COLUMN_WIDTH).ceil ).each do |part|
            font.draw( part, pos.x + 18, pos.y, 1, 1, 1, WHITE )
            pos.move_by!( 0, size.height )
          end
        else
          font.draw( text, pos.x + 18, pos.y, 1, 1, 1, WHITE )
          pos.move_by!( 0, size.height )
        end
      end
    end

    def wrap( text, pieces = 2 )
      return [text] if pieces == 1

      pos   = text.size / pieces
      nspace = text.index( ' ', pos )
      pspace = text.rindex( ' ', pos )

      space = (nspace - pos).abs > (pspace - pos).abs ? pspace : nspace

      [text[0...space]] + wrap( text[space + 1..-1], pieces - 1 )
    end
    
    def draw_cell( pos, cell )
      draw_rectangle( pos.offset( 1, 1 ), CELL_SIZE.deflate( 2, 2 ), 1, WHITE )

      if cell.number != 0
        @font[:number].draw( cell.number, pos.x + 2, pos.y + 1, 1, 1, 1, BLACK )
      end

      unless cell.user.empty?
        pos.move_by!( @font[:cell].centred_in( cell.user, CELL_SIZE ) )
        @font[:cell].draw( cell.user, pos.x, pos.y + 1, 1, 1, 1, BLACK )
      end
    end
  end
end

filename = ARGV[0] || '2014-4-22-LosAngelesTimes.puz'
puz = PuzzleLoader.new( filename )

puts "Size:  #{puz.width} x #{puz.height}"
puts "Clues: #{puz.num_clues}"
puts 'Scrambled!' if puz.scrambled?

puts %(
Title:      #{puz.title}
Author:     #{puz.author}
Copyright:  #{puz.copyright}
)

cgrid = CrosswordGrid.new( puz.rows, puz.clues )

Crossword::Game.new( cgrid ).show
