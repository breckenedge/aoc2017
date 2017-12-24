require 'pry'

regs = (:a..:h).each_with_object({}) { |sym, hsh| hsh[sym] = 0 }
head = 0
muls = 0
calls = 0

instructions = [
  -> { regs[:b] = 93 },
  -> { regs[:c] = regs[:b] },
  -> { (head += 1) if regs[:a] != 0 },
  -> { head += 4 },
  -> { regs[:b] = regs[:b] * 100; muls += 1 },
  -> { regs[:b] -= -100000 },
  -> { regs[:c] = regs[:b] },
  -> { regs[:c] -= -17000 },
  -> { regs[:f] = 1 },
  -> { regs[:d] = 2 },
  -> { regs[:e] = 2 },
  -> { regs[:g] = regs[:d] },
  -> { regs[:g] = regs[:g] * regs[:e]; muls += 1 },
  -> { regs[:g] -= regs[:b] },
  -> { (head += 1) if regs[:g] != 0 },
  -> { regs[:f] = 0 },
  -> { regs[:e] -= -1 },
  -> { regs[:g] = regs[:e] },
  -> { regs[:g] -= regs[:b] },
  -> { (head += -9) if regs[:g] != 0 },
  -> { regs[:d] -= -1 },
  -> { regs[:g] = regs[:d] },
  -> { regs[:g] -= regs[:b] },
  -> { (head += -14) if regs[:g] != 0 },
  -> { (head += 1) if regs[:f] != 0 },
  -> { regs[:h] -= -1 },
  -> { regs[:g] = regs[:b] },
  -> { regs[:g] -= regs[:c] },
  -> { (head += 1) if regs[:g] != 0 },
  -> { head += 2 },
  -> { regs[:b] -= -17 },
  -> { head += -24 }
]

escape = instructions.size - 1

loop do
  calls += 1
  instructions[head].call
  head += 1
  break if head < 0 || head > escape
end

puts muls
