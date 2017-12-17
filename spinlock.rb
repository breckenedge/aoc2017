require './circular_list'

class Spinlock
  attr_reader :list, :position, :spins, :jump

  def initialize(spins = 2017, jump = 3)
    @list = CircularList.new([0])
    @position = 0
    @spins = spins
    @jump = jump
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
  spinlock = Spinlock.new(2017, ARGV[0] ? ARGV[0].to_i : 3)
  spinlock.perform
  puts spinlock.list[spinlock.position + 2]
end
