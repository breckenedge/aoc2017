require 'pry'

tape = []
steps = 12_208_951
steps.times { tape << 0 }
cursor = 0
state = :a

states = {
  a: [
    -> { tape[cursor] = 1; cursor += 1; state = :b },
    -> { tape[cursor] = 0; cursor -= 1; state = :e }
  ],
  b: [
    -> { tape[cursor] = 1; cursor -= 1; state = :c },
    -> { tape[cursor] = 0; cursor += 1; state = :a }
  ],
  c: [
    -> { tape[cursor] = 1; cursor -= 1; state = :d },
    -> { tape[cursor] = 0; cursor += 1; state = :c }
  ],
  d: [
    -> { tape[cursor] = 1; cursor -= 1; state = :e },
    -> { tape[cursor] = 0; cursor -= 1; state = :f }
  ],
  e: [
    -> { tape[cursor] = 1; cursor -= 1; state = :a },
    -> { tape[cursor] = 1; cursor -= 1; state = :c }
  ],
  f: [
    -> { tape[cursor] = 1; cursor -= 1; state = :e },
    -> { tape[cursor] = 1; cursor += 1; state = :a }
  ]
}

steps.times {
  states[state][tape[cursor]].call
}

puts tape.count { |c| c == 1 }

__END__
Begin in state A.
Perform a diagnostic checksum after 12208951 steps.

In state A:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state B.
  If the current value is 1:
    - Write the value 0.
    - Move one slot to the left.
    - Continue with state E.

In state B:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the left.
    - Continue with state C.
  If the current value is 1:
    - Write the value 0.
    - Move one slot to the right.
    - Continue with state A.

In state C:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the left.
    - Continue with state D.
  If the current value is 1:
    - Write the value 0.
    - Move one slot to the right.
    - Continue with state C.

In state D:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the left.
    - Continue with state E.
  If the current value is 1:
    - Write the value 0.
    - Move one slot to the left.
    - Continue with state F.

In state E:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the left.
    - Continue with state A.
  If the current value is 1:
    - Write the value 1.
    - Move one slot to the left.
    - Continue with state C.

In state F:
  If the current value is 0:
    - Write the value 1.
    - Move one slot to the left.
    - Continue with state E.
  If the current value is 1:
    - Write the value 1.
    - Move one slot to the right.
    - Continue with state A.
