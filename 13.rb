input = (ARGV.empty? ? DATA : ARGF).readlines.map(&:chomp)

$layers = Hash.new

class Layer
  attr_reader :depth, :sentry, :direction

  def initialize(name, depth)
    @depth = depth
    @sentry = Sentry.new
    @direction = 1
  end

  def tick
    if @sentry.position == (depth - 1)
      @direction = -1
    elsif @sentry.position == 0
      @direction = 1
    end
    @sentry.position += @direction
  end

  def position
    @sentry.position
  end
end

class Sentry
  attr_accessor :position

  def initialize
    @position = 0
  end
end

class Packet
  attr_reader :layer

  def initialize
    @layer = 0
  end

  def tick
    @layer += 1
  end

  def caught?
    return false unless $layers[@layer]
    $layers[@layer].position == 0
  end
end

input.each do |l|
  layer, depth = l.split(': ')
  $layers[layer.to_i] = Layer.new(layer.to_i, depth.to_i)
end

rounds = $layers.keys.last + 1
packet = Packet.new
score = 0

rounds.times do |r|
  puts "Picosecond #{r}:"
  if packet.caught?
    puts "Caught in layer #{r}"
    inc = ($layers[r]&.depth || 0) * r
    score += inc
  end
  $layers.values.each(&:tick)
  packet.tick
end

puts score

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
