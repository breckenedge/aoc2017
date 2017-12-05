#!/usr/local/bin/python3

def steps_to_escape(instructions):
    pos = 0
    steps = 0
    esc = len(instructions)
    while pos >= 0 and pos < esc:
        curr = instructions[pos]
        instructions[pos] = instructions[pos] + 1
        pos = pos + curr
        steps += 1
    return steps

if __name__ == '__main__':
    print(steps_to_escape([0, 3, 0, 1, -3]))
    print(steps_to_escape([int(s) for s in open('05.input', 'r').read().splitlines()]))
