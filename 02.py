#!/usr/local/bin/python3

import csv

def main(path):
    checksum = 0
    with open(path, 'r', newline='') as f:
        reader = csv.reader(f, delimiter="\t")
        for row in reader:
            checksum = checksum + evenly_divisible_value_in([int(i) for i in row])
    return checksum

def evenly_divisible_value_in(a):
    for i in a:
        for j in a:
            if i // j == i / j and j != i:
                return (i // j)

if __name__ == '__main__':
    print(main('./02.input.test'))
    print(main('./02.input'))
