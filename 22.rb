require 'pry'

Coord = Struct.new(:x, :y)

class Game
  attr_accessor :infected_nodes
end

class Carrier
  attr_reader :game, :position, :direction, :infections

  def initialize(game, x = 0, y = 0, direction = :n)
    @game = game
    @position = Coord.new(x, y)
    @direction = direction
    @infections = 0
  end

  def burst
    if clean?
      turn_left
      infect
      move
    else
      turn_right
      clean
      move
    end
  end

  def infect
    @infections += 1
    @game.infected_nodes << @position.clone
  end

  def clean
    @game.infected_nodes.delete(@position)
  end

  def clean?
    game.infected_nodes.none? { |node| node == @position }
  end

  def move
    @position.x += DIRECTIONS[@direction].x
    @position.y += DIRECTIONS[@direction].y
  end

  def turn_right
    dindex = DIRECTIONS.keys.index(@direction) + 1
    if dindex > 3
      dindex = dindex % 4
    end
    @direction = DIRECTIONS.keys[dindex]
  end

  def turn_left
    dindex = DIRECTIONS.keys.index(@direction) - 1
    if dindex < 0
      dindex += 4
    end
    @direction = DIRECTIONS.keys[dindex]
  end
end

DIRECTIONS = {
  :n => Coord.new( 0,  1),
  :e => Coord.new( 1,  0),
  :s => Coord.new( 0, -1),
  :w => Coord.new(-1,  0),
}

if __FILE__ == $0
  input = (ARGV.empty? ? DATA : ARGF).readlines.map(&:chomp)
  input

  game = Game.new

  game.infected_nodes = []

  input.reverse.each_with_index do |row, i|
    row.split('').each_with_index do |col, j|

      if col == '#'
        game.infected_nodes << Coord.new(j - (input.size / 2), i - (input.size / 2))
      end
    end
  end

  carrier = Carrier.new(game, 0, 0, :n)

  10_000.times { carrier.burst }

  puts carrier.infections
end

__END__
..#
#..
...
