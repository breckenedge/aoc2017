require 'irb'
require './circular_list'

class Spiral
  Coord = Struct.new(:x, :y)

  MOVES = {
    n: Coord.new( 0,  1),
    s: Coord.new( 0, -1),
    e: Coord.new( 1,  0),
    w: Coord.new(-1,  0),
  }

  DIRECTIONS = CircularList.new([:e, :n, :w, :s])

  CARDINALS = {
     n: Coord.new( 0, -1),
    ne: Coord.new( 1, -1),
     e: Coord.new( 1,  0),
    se: Coord.new( 1,  1),
     s: Coord.new( 0,  1),
    sw: Coord.new(-1,  1),
     w: Coord.new(-1,  0),
    nw: Coord.new(-1, -1),
  }

  attr_reader :grid, :head, :direction

  def initialize
    @grid = {}
    @head = Coord.new(0, 0)
    @direction_index = 0 # :e
    @ticks = 0
  end

  def tick
    @ticks += 1
    @grid[[@head.x, @head.y]] = (sum = cardinals.values.sum) > 0 ? sum : 1
    @head.x += MOVES[direction].x
    @head.y += MOVES[direction].y
    turn_left if clear_left?
  end

  def cardinals
    @grid.slice(*CARDINALS.values.map { |c| [@head.x + c.x, @head.y + c.y] })
  end

  def manhattan_distance
    @grid.keys.last.sum { |i| i.abs }
  end

  private

  def clear_left?
    left = @direction_index + 1
    move = MOVES[DIRECTIONS[left]]
    @grid[[@head.x + move.x, @head.y + move.y]].nil?
  end

  def clear_right?
    right = @direction_index - 1
    move = MOVES[DIRECTIONS[right]]
    @grid[[@head.x + move.x, @head.y + move.y]].nil?
  end

  def direction
    DIRECTIONS[@direction_index]
  end

  def turn_left
    @direction_index += 1
  end

  def turn_right
    @direction_index -= 1
  end
end

if __FILE__ == $0
  input = (ARGV[0] ? ARGV[0].to_i : 265149)

  spiral1 = Spiral.new
  input.times { spiral1.tick }

  puts "Manhattan distance: #{spiral1.manhattan_distance}"

  spiral2 = Spiral.new
  loop do
    spiral2.tick
    break if spiral2.grid.values.last > input
  end
  puts "Final value written: #{spiral2.grid.values.last}"
end
