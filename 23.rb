require 'pry'

a = 1
b = 0
c = 0
d = 0
e = 0
f = 0
g = 0
h = 0
head = 0
calls = 0

instructions = {
  0 => -> { b = 93 },
  1 => -> { c = b },
  2 => -> { head += 1 if a != 0 },
  3 => -> { head += 4 },
  4 => -> { b *= 100 },
  5 => -> { b += 100000 },
  6 => -> { c = b },
  7 => -> { c += 17000 },
  8 => -> { f = 1 },
  10 => -> { e = 2 },
  11 => -> { head = 24 if b % e == 0 },
  16 => -> { e += 1 },
  19 => -> { head = 10 if e != b },
  24 => -> { head = 27 if f != 0 },
  25 => -> { h += 1 },
  28 => -> { head = 31 if b == c },
  30 => -> { b += 17 },
  31 => -> { head = 7 },
}

loop do
  break if head < 0 || head > 31
  instructions[head]&.call
  calls += 1
  head += 1
end

puts h

__END__
set b 93
set c b
jnz a 2
jnz 1 5
mul b 100
sub b -100000
set c b
sub c -17000
set f 1
set d 2
set e 2
set g d
mul g e
sub g b
jnz g 2
set f 0
sub e -1
set g e
sub g b
jnz g -8
sub d -1
set g d
sub g b
jnz g -13
jnz f 2
sub h -1
set g b
sub g c
jnz g 2
jnz 1 3
sub b -17
jnz 1 -23
