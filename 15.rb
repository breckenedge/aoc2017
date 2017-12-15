require 'pry'

a_factor = 16807
b_factor = 48271
comb = 2147483647
mask = 0xFFFF

a_mod = 4
b_mod = 8

# a = 65
a = 116
# b = 8921
b = 299

count = 0
# times = 5
times = 5_000_000

as = []
bs = []

while as.length < times do
  a = (a * a_factor) % comb
  as << a if a % a_mod == 0
end

while bs.length < times do
  b = (b * b_factor) % comb
  bs << b if b % b_mod == 0
end

0.upto(times - 1) do |i|
  count += 1 if (bs[i] & mask == as[i] & mask)
end

puts count

# not 85
