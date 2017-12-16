#!/usr/bin/ruby

require './circular_list'
require 'pry'

class Dance
  attr_reader :positions

  def initialize(starting)
    @positions = starting.split('')
  end

  def spin(times)
    @positions.rotate!(-times)
  end

  def exchange(pos1, pos2)
    tmp = @positions[pos1]
    @positions[pos1] = @positions[pos2]
    @positions[pos2] = tmp
  end

  def partner(prog1, prog2)
    pos1 = @positions.index(prog1)
    pos2 = @positions.index(prog2)
    exchange(pos1, pos2)
  end
end

if __FILE__ == $0
  inputs = (ARGV.empty? ? DATA : ARGF).readlines.map(&:chomp).first.split(',')
  dance = Dance.new("giadhmkpcnbfjelo")
  #dance = Dance.new("abcde")
  moves = inputs.map { |input|
    case input[0]
    when 's'
      [:spin, input.sub('s', '').to_i]
    when 'x'
      [:exchange, *input.sub('x', '').split('/').map(&:to_i)]
    when 'p'
      [:partner, *input.sub('p', '').split('/')]
    end
  }

  positions = []
  repeat = 0

  loop do
    moves.each do |move|
      dance.send(*move)
    end
    break if positions.index(dance.positions.join)
    positions << dance.positions.join
    repeat += 1
  end

  puts CircularList.new(positions)[1_000_000_000 % repeat - 2] # -1 for initial and -1 for off-by-one :-(
end


__END__
s1,x3/4,pe/b
