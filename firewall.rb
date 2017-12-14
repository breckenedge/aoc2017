#!/usr/bin/ruby

class Firewall
  attr_reader :layers

  def initialize(layers)
    @layers = layers
  end

  def severity(delay = 0)
    layers.sum { |offset, depth| ((delay + offset) % (depth * 2 - 2)) == 0 ? (offset * depth) : 0 }
  end

  def minimum_delay
    delay = 0

    loop do
      break if layers.none? { |offset, depth| ((delay + offset) % (depth * 2 - 2)).zero? }
      delay += 1
    end

    delay
  end
end

if __FILE__ == $0
  input = (ARGV.empty? ? DATA : ARGF).readlines.map(&:chomp)
  layers = {}

  input.each do |line|
    offset, depth = line.split(':').map(&:to_i)
    layers[offset] = depth
  end

  firewall = Firewall.new(layers)

  puts "Severity with delay 0: #{firewall.severity}"
  puts "Minimum delay for 0 severity: #{firewall.minimum_delay}"
end

__END__
0: 3
1: 2
2: 4
4: 6
6: 4
8: 6
10: 5
12: 8
14: 8
16: 6
18: 8
20: 6
22: 10
24: 8
26: 12
28: 12
30: 8
32: 12
34: 8
36: 14
38: 12
40: 18
42: 12
44: 12
46: 9
48: 14
50: 18
52: 10
54: 14
56: 12
58: 12
60: 14
64: 14
68: 12
70: 17
72: 14
74: 12
76: 14
78: 14
82: 14
84: 14
94: 14
96: 14
