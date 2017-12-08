#[
--- Part Two ---

As a stress test on the system, the programs here clear the grid and then store the value 1 in square 1. Then, in the same allocation order as shown above, they store the sum of the values in all adjacent squares, including diagonals.

So, the first few squares' values are chosen as follows:

    Square 1 starts with the value 1.
    Square 2 has only one adjacent filled square (with value 1), so it also stores 1.
    Square 3 has both of the above squares as neighbors and stores the sum of their values, 2.
    Square 4 has all three of the aforementioned squares as neighbors and stores the sum of their values, 4.
    Square 5 only has the first and fourth squares as neighbors, so it gets the value 5.

Once a square is written, its value does not change. Therefore, the first few squares would receive the following values:

147  142  133  122   59
304    5    4    2   57
330   10    1    1   54
351   11   23   25   26
362  747  806--->   ...

What is the first value written that is larger than your puzzle input?

]#

# Time: O(n)
# Space: O(n) (using a hash)

import math
import rationals
import tables
import hashes

type
  Location = tuple
    x: int
    y: int

proc hash(x: Location): Hash =
  var key = newStringOfCap(len($x.x) + len($x.y) + 1)
  key.add($x.x)
  key.add(":")
  key.add($x.y)
  result = key.hash

proc solve(n: int): int =
  var
    x = 0
    y = 0
    steps = 0
    square = 1
    grid = newTable[Location, int]()
  grid[(x, y)] = square
  while true:
    for j in 0 ..< 4:
      for k in 0 ..< steps:
        case j  # walk
        of 0:
          case k  # spiral turn
          of 0:
            inc x
          else:
            inc y
        of 1:
          dec x
        of 2:
          dec y
        of 3:
          inc x
        else:
          discard
        # walk adjacents
        square = 0
        for x2 in -1 .. 1:
          for y2 in -1 .. 1:
            square.inc(grid.getOrDefault((x + x2, y + y2)))
        grid[(x, y)] = square
        if square > n:
          return square
    steps.inc(2)

echo $solve(2)
echo $solve(10)
echo $solve(54)
echo $solve(351)
echo $solve(368078)
