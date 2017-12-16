#!/usr/bin/ruby
#
require 'pry'

class Dance
  attr_reader :positions

  def initialize(programs = 16)
    @positions = programs.times.map { |i| (i + 97).chr }
  end

  def spin(input)
    times = input.sub('s', '').to_i
    @positions.rotate!(-times)
  end

  def exchange(input)
    pos1, pos2 = input.sub('x', '').split('/').map(&:to_i)
    tmp = @positions[pos1]
    @positions[pos1] = @positions[pos2]
    @positions[pos2] = tmp
  rescue
    binding.pry
  end

  def partner(input)
    prog1, prog2 = input.sub('p', '').split('/')
    pos1 = @positions.index(prog1)
    pos2 = @positions.index(prog2)
    exchange("x#{pos1}/#{pos2}")
  end
end

if __FILE__ == $0
  inputs = (ARGV.empty? ? DATA : ARGF).readlines.map(&:chomp).first.split(',')

  dance = Dance.new("giadhmkpcnbfjelo")
  inputs.each do |input|
    case input[0]
    when 's'
      dance.spin(input)
    when 'x'
      dance.exchange(input)
    when 'p'
      dance.partner(input)
    end
  end

  puts dance.positions.join
end


__END__
s1,x3/4,pe/b
