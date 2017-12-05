#!/usr/local/bin/python3

def inverse_captcha(nums):
  total = 0
  length = len(nums)
  for i, curr in enumerate(nums):
    j = i + length // 2
    if j >= length:
      j = j - length
    if nums[j] == curr:
      total = total + curr
  return total

if __name__ == '__main__':
  print(inverse_captcha([1, 2, 1, 2]))
  print(inverse_captcha([1, 2, 2, 1]))
  print(inverse_captcha([1, 2, 3, 4, 2, 5]))
  print(inverse_captcha([1, 2, 3, 1, 2, 3]))
  print(inverse_captcha([1, 2, 1, 3, 1, 4, 1, 5]))
  print(inverse_captcha([int(char) for char in list(open('01.input').read().strip())]))
