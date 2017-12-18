require 'pry'

class Duet
  attr_reader :output

  def initialize(song)
    @song = parse(song)
    @registers = {}
    ('a'..'p').each { |chr| @registers[chr] = 0 }
    @last_sound_played = nil
    @head = 0
    @output = []
  end

  def parse(strings)
    @instructions = strings.map { |line|
      line.split(' ')
    }
  end

  def play(&block)
    loop do
      break if @head.abs > (@instructions.length - 1)
      puts @instructions[@head].join(' ')
      send(*@instructions[@head])
      @head += 1
    end
  end

  # plays a sound with freq equal to X
  def snd(x)
    @last_sound_played = @registers[x]
    @output << @last_sound_played
  end

  # set register X to value of Y
  def set(x, y)
    @registers[x] = @registers.fetch(y, y.to_i)
  end

  def add(x, y)
    @registers[x] = @registers[x] + @registers.fetch(y, y.to_i)
  end

  def mul(x, y)
    @registers[x] = @registers[x] * @registers.fetch(y, y.to_i)
  end

  # X modulo Y
  def mod(x, y)
    @registers[x] = @registers[x] % @registers.fetch(y, y.to_i)
  end

  # recovers the frequency of the last sound played, but only if the value of X is greater than zero
  def rcv(x)
    if @registers.fetch(x, -1) > 0
      @registers[x] = @last_sound_played
      print @last_sound_played
      exit
    end
  end

  # jumps with an offset of Y but only if X is greater than zero
  def jgz(x, y)
    if @registers[x] && @registers[x] > 0
      @head += @registers.fetch(y, y.to_i) - 1
    end
  end
end

if __FILE__ == $0
  input = (ARGV.empty? ? DATA : ARGF).readlines.map(&:chomp)
  d = Duet.new(input)
  d.play
  puts d.output.last
end

__END__
set a 1
add a 2
mul a a
mod a 5
snd a
set a 0
rcv a
jgz a -1
set a 1
jgz a -2
