#!/usr/local/bin/python3

import csv

def main(path):
    checksum = 0
    with open(path, 'r', newline='') as f:
        reader = csv.reader(f, delimiter="\t")
        for row in reader:
            minimum, maximum = minmax([int(x) for x in row])
            checksum = checksum + maximum - minimum
    return checksum

def minmax(a):
    maximum = a[0];
    minimum = a[0];
    for x in a:
        if x > maximum:
            maximum = x
        elif x < minimum:
            minimum = x
    return (minimum, maximum)

if __name__ == '__main__':
    print(main('./02.input.test'))
    print(main('./02.input'))
