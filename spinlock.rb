require './circular_list'

class Spinlock
  attr_reader :list, :position, :spins, :jump

  def initialize(spins = 2017, jump = 3)
    @list = CircularList.new([0])
    @position = 0
    @spins = spins
    @jump = jump
  end

  def second_after(n)
    curr = 0
    pos = 0
    n.times do |i|
      pos = (pos + jump) % (i + 1)
      curr = (i + 1) if pos == 0
      pos += 1
    end
    curr
  end

  def perform(&block)
    spins.times do |i|
      @position += jump + 1
      @position = position % @list.size
      @list.insert(@position + 1, i + 1)
      yield(self, i) if block_given?
    end
  end
end

if __FILE__ == $0
  spinlock = Spinlock.new(ARGV[0] ? ARGV[0].to_i : 2017, ARGV[1] ? ARGV[1].to_i : 3)
  spinlock.perform
  puts spinlock.list[spinlock.position + 2]
  puts spinlock.second_after(50_000_000)
end
