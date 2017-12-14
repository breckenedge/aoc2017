require 'pry'
require './circular_list'

input = DATA.readlines.map(&:chomp)

hexes = []

128.times do |i|
  line = "#{input[0]}-#{i}"
  ords = line.each_char.map(&:ord) + [17, 31, 73, 47, 23]

  list = CircularList.new((0..255).to_a)

  current_pos = 0
  current_skip_size = 0

  64.times do
    ords.each do |length|
      list[current_pos, length] = Array(list[current_pos, length]).reverse
      current_pos += length + current_skip_size
      current_skip_size += 1
    end
  end

  chunks = list.each_slice(16).map { |slice| slice.reduce(&:^) }

  hexes << chunks.map { |c| c.to_s(2).rjust(8, '0') }
end

pp hexes

count = 0

pp hexes.flatten.join.each_char { |c| c == "1" ? count += 1 : nil }


pp count

__END__
ugkiagan
