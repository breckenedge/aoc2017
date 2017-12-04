#!/usr/local/bin/python3

def count_valid_passphrases(strings):
    return len(list(filter(lambda s: is_valid_passphrase(s), strings)))

def is_valid_passphrase(string):
    words = string.split(" ")
    s_words = list(map(lambda w: ''.join(sorted(list(w))), words))
    return len(s_words) == len(set(s_words))

if __name__ == '__main__':
    print(count_valid_passphrases(["aa bb cc dd ee", "aa bb cc dd aa", "aa bb cc dd aaa"]))
    print(count_valid_passphrases([s.strip() for s in open('04.input', 'r').read().splitlines()]))
