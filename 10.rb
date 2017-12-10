require './circular_list'

lengths = $stdin.read.split(',').map(&:to_i)
current_pos = 0

list = CircularList.new((0..255).to_a)

lengths.each_with_index do |length, skip_size|
  list[current_pos, length] = Array(list[current_pos, length]).reverse
  current_pos += length + skip_size
end

puts list[0] * list[1]
