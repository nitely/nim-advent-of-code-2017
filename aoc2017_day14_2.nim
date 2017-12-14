#[
--- Part Two ---

Now, all the defragmenter needs to know is the number of regions. A region is a group of used squares that are all adjacent, not including diagonals. Every used square is in exactly one region: lone used squares form their own isolated regions, while several adjacent squares all count as a single region.

In the example above, the following nine regions are visible, each marked with a distinct digit:

11.2.3..-->
.1.2.3.4
....5.6.
7.8.55.9
.88.5...
88..5..8
.8...8..
88.8.88.-->
|      |
V      V

Of particular interest is the region marked 8; while it does not appear contiguous in this small view, all of the squares marked 8 are connected when considering the whole 128x128 grid. In total, in this example, 1242 regions are present.

How many regions are present given your key string?

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

type
  Grid = seq[array[128, int]]

proc visit(grid: var Grid, a, b: int) =
  if grid[a][b] != 1:
    return
  inc grid[a][b]
  for i in -1 .. 1:
    if 0 <= a + i and a + i < 128:
      grid.visit(a + i, b)
  for i in -1 .. 1:
    if 0 <= b + i and b + i < 128:
      grid.visit(a, b + i)

proc solve(s: string): int =
  var grid = newSeq[array[128, int]](128)
  for i in 0 ..< 128:
    for j, h in knotHash(s & '-' & $i):
      let bits = h.parseHexInt
      for k in 0 .. 3:
        # 3-k to process in 8,4,2,1 order (left to right grid)
        if (bits and (2 ^ (3 - k))) != 0:
          grid[i][j * 4 + k] = 1
  for i in 0 ..< 128:
    for j in 0 ..< 128:
      if grid[i][j] == 1:
        inc result
      grid.visit(i, j)

echo $solve("flqrgnkx")
echo $solve("oundnydw")
