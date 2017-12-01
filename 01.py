#!/usr/local/bin/python3

def main(path):
  f = open(path, 'r')
  nums = [int(char) for char in list(f.read().strip())]
  return inverse_captcha(nums)

def inverse_captcha(nums):
  total = 0
  length = len(nums)
  for i, curr in enumerate(nums):
    if i == length - 1:
      nxt = nums[0]
    else:
      nxt = nums[i + 1]
    if nxt == curr:
      total = total + curr
  return total

if __name__ == '__main__':
  print(inverse_captcha([1, 1, 2, 2]))
  print(inverse_captcha([1, 1, 1, 1]))
  print(inverse_captcha([1, 2, 3, 4]))
  print(inverse_captcha([9, 1, 2, 1, 2, 1, 2, 9]))
  print(main('./01.input'))
