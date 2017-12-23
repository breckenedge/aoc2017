require 'pry'
require 'io/console'
require 'ruby-prof'

Coord = Struct.new(:x, :y, :state)

class Game
  attr_accessor :nodes, :carrier

  def initialize
    @carrier = Carrier.new(self, 0, 0, :n)
    @nodes = Hash.new { |hsh, x| hsh[x] = [] }
  end

  def draw
    my, mx = IO.console.winsize.map { |i| i / 2 - 1 }
    mx = mx / 2

    # mx = 50 # nodes.max { |n| n.x.abs }.x.abs
    # my = 25 # nodes.max { |n| n.y.abs }.y.abs

    buff = ""

    my.downto(-my).each do |y|
      (-mx..mx).each do |x|
        n = find_node(x, y)
        o = case n&.state
            when :infected
              '#'
            when :weakened
              'W'
            when :flagged
              'F'
            else
              '.'
            end
        if carrier.x == x && carrier.y == y
          buff << "[#{o}"
        else
          buff << " #{o}"
        end
      end
      buff << "\n"
    end
    puts buff
  end

  def set_node(x, y, state)
    if (n = find_node(x, y))
      n.state = state
    else
      nodes[x] << Coord.new(x, y, state)
    end
  end

  def clean_node(x, y)
    nodes[x].delete(find_node(x, y))
  end

  def find_node(x, y)
    nodes[x].find { |n| n.y == y }
  end
end

class Carrier
  attr_reader :game, :position, :direction, :infections

  def x
    @position.x
  end

  def y
    @position.y
  end

  def initialize(game, x = 0, y = 0, direction = :n)
    @game = game
    @position = Coord.new(x, y)
    @direction = direction
    @infections = 0
  end

  def burst
    if clean?
      turn_left
      weaken
      move
    elsif weakened?
      infect
      move
    elsif infected?
      turn_right
      flag
      move
    elsif flagged?
      reverse
      clean
      move
    else
      raise StandardError
    end
  end

  def infected?
    current_node.state == :infected
  end

  def infect
    @infections += 1
    @game.set_node(current_node.x, current_node.y, :infected)
  end

  def weakened?
    return unless (n = current_node)
    n.state == :weakened
  end

  def weaken
    @game.set_node(x, y, :weakened)
  end

  def flagged?
    return unless (n = current_node)
    n.state == :flagged
  end

  def flag
    @game.set_node(current_node.x, current_node.y, :flagged)
  end

  def clean
    @game.clean_node(current_node.x, current_node.y)
  end

  def clean?
    current_node.nil?
  end

  def current_node
    @game.find_node(@position.x, @position.y)
  end

  def move
    @position.x += DIRECTIONS[@direction].x
    @position.y += DIRECTIONS[@direction].y
  end

  def reverse
    dindex = DIRECTIONS.keys.index(@direction) + 2
    if dindex > 3
      dindex = dindex % 4
    end
    @direction = DIRECTIONS.keys[dindex]
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

  game = Game.new

  input.reverse.each_with_index do |row, i|
    row.split('').each_with_index do |col, j|

      if col == '#'
        game.set_node(j - (input.size / 2), i - (input.size / 2), :infected)
      end
    end
  end

  10_000_000.times { |i|
    puts i if i % 100000 == 0
    game.carrier.burst
  }

  puts game.carrier.infections
end

__END__
..#
#..
...
