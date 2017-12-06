banks = File.readlines('06.input')[0].split("\t").map(&:to_i)
#banks = [0, 2, 7, 0]
curr = banks.clone
sln = []

histories = [banks]

loop do
  blocks = curr.max
  idx = curr.find_index(blocks)
  curr[idx] = 0

  blocks.times do |i|
    j = (idx + 1 + i) % curr.size
    curr[j] = curr[j] + 1
  end

  if histories.any? { |h| h == curr }
    sln = curr
    break
  end

  histories.push(curr.clone)
  curr = curr.clone
end

puts histories.size - histories.find_index(sln)

