require 'pry'

class Duet
  attr_reader :song, :programs, :instructions

  def initialize(song)
    @instructions = parse(song)
    @programs = [
      Program.new(self, 0),
      Program.new(self, 1)
    ]
  end

  def parse(strings)
    strings.map { |line| line.split(' ') }
  end

  def deadlock?
    @programs.all? { |p| p.waiting && p.queue.empty? }
  end

  def play
    loop do
      @programs.each do |p|
        p.play
      end
      if deadlock?
        break
      end
    end
    puts @programs[1].sends
  end
end

class Program
  attr_accessor :waiting
  attr_reader :queue, :sends

  def initialize(duet, id)
    @duet = duet
    @id = id
    @registers = {}
    ('a'..'p').each { |chr| @registers[chr] = 0 }
    @registers['p'] = id
    @head = 0
    @queue = []
    @sends = 0
    @waiting = false
  end

  def instructions
    @duet.instructions
  end

  def play
    loop do
      send(*instructions[@head])
      if @waiting && @queue.empty?
        break
      end
      @head += 1
    end
  end

  def other
    @duet.programs.find { |p| self != p }
  end

  # send X to the other program
  def snd(x)
    @sends += 1
    other.queue.push(@registers.fetch(x, x))
    other.waiting = false
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

  def mod(x, y)
    @registers[x] = @registers[x] % @registers.fetch(y, y.to_i)
  end

  # pop from queue into register X
  def rcv(x)
    if queue.any?
      @waiting = false
      @registers[x] = queue.shift
    else
      @waiting = true
    end
  end

  # jumps with an offset of Y but only if X is greater than zero
  def jgz(x, y)
    if x =~ /[a-p]/
      if @registers[x] > 0
        @head += @registers.fetch(y, y.to_i) - 1
      end
    elsif Integer(x) > 0
      @head += Integer(y.to_i) - 1
    end
  end
end

if __FILE__ == $0
  input = (ARGV.empty? ? DATA : ARGF).readlines.map(&:chomp)
  duet = Duet.new(input)
  duet.play
end

__END__
snd 1
snd 2
snd p
rcv a
rcv b
rcv c
rcv d
