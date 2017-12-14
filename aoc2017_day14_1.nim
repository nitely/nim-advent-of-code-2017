#[
--- Day 14: Disk Defragmentation ---

Suddenly, a scheduled job activates the system's disk defragmenter. Were the situation different, you might sit and watch it for a while, but today, you just don't have that kind of time. It's soaking up valuable system resources that are needed elsewhere, and so the only option is to help it finish its task as soon as possible.

The disk in question consists of a 128x128 grid; each square of the grid is either free or used. On this disk, the state of the grid is tracked by the bits in a sequence of knot hashes.

A total of 128 knot hashes are calculated, each corresponding to a single row in the grid; each hash contains 128 bits which correspond to individual grid squares. Each bit of a hash indicates whether that square is free (0) or used (1).

The hash inputs are a key string (your puzzle input), a dash, and a number from 0 to 127 corresponding to the row. For example, if your key string were flqrgnkx, then the first row would be given by the bits of the knot hash of flqrgnkx-0, the second row from the bits of the knot hash of flqrgnkx-1, and so on until the last row, flqrgnkx-127.

The output of a knot hash is traditionally represented by 32 hexadecimal digits; each of these digits correspond to 4 bits, for a total of 4 * 32 = 128 bits. To convert to bits, turn each hexadecimal digit to its equivalent binary value, high-bit first: 0 becomes 0000, 1 becomes 0001, e becomes 1110, f becomes 1111, and so on; a hash that begins with a0c2017... in hexadecimal would begin with 10100000110000100000000101110000... in binary.

Continuing this process, the first 8 rows and columns for key flqrgnkx appear as follows, using # to denote used squares, and . to denote free ones:

##.#.#..-->
.#.#.#.#
....#.#.
#.#.##.#
.##.#...
##..#..#
.#...#..
##.#.##.-->
|      |
V      V

In this example, 8108 squares are used across the entire 128x128 grid.

Given your actual key string, how many squares are used?

]#

import strutils
import math

#### from day 10

proc reverse(n: var seq[int], first, last: int) =
  var x = first
  var y = max(0, last)
  while x < y:
    swap(n[(x mod n.len)], n[(y mod n.len)])
    dec(y)
    inc(x)

proc formatHex(n: int): string =
  result = newString(2)
  result[0] = "0123456789abcdef"[n div 16]
  result[1] = "0123456789abcdef"[n mod 16]

proc knotHash(s: string): string =
  var lengths = newSeq[int](s.len)
  for i, c in s:
    lengths[i] = c.ord
  lengths.add([17, 31, 73, 47, 23])
  var nums = newSeq[int](256)
  for i in 0 ..< nums.len:
    nums[i] = i
  var
    pos = 0
    skipSize = 0
  for _ in 0 ..< 64:
    for ln in lengths:
      nums.reverse(pos, pos + ln - 1)
      pos.inc((ln + skipSize) mod nums.len)
      inc skipSize
  result = newStringOfCap(32)
  var d = 0
  for i in 0 ..< 16:
    for j in 16 * i ..< 16 * i + 16:
      d = d xor nums[j]
    result.add(d.formatHex)
    d = 0

#### end from day 10

proc parseHexInt(c: char): int =
  case c
  of '0'..'9':
    result = ord(c) - ord('0')
  of 'a'..'f':
    result = ord(c) - ord('a') + 10
  of 'A'..'F':
    result = ord(c) - ord('A') + 10
  else: raise newException(ValueError, "invalid integer: " & c)

proc solve(s: string): int =
  for i in 0 ..< 128:
    for j, h in knotHash(s & '-' & $i):
      let bits = h.parseHexInt
      for k in 0 .. 3:
        # 3-k to process in 8,4,2,1 order (left to right grid)
        if (bits and (2 ^ (3 - k))) != 0:
          inc result

echo $solve("flqrgnkx")
echo $solve("oundnydw")
