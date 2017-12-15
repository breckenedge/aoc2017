a_factor = 16807
b_factor = 48271
comb = 2147483647
mask = 0xFFFF

# a = 65
a = 116
# b = 8921
b = 299

count = 0
times = 40_000_000

times.times do
  a = (a * a_factor) % comb
  b = (b * b_factor) % comb
  count += 1 if a & mask == b & mask
end

puts count

# not 156044
