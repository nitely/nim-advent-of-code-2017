#[
--- Day 3: Spiral Memory ---

You come across an experimental new kind of memory stored on an infinite two-dimensional grid.

Each square on the grid is allocated in a spiral pattern starting at a location marked 1 and then counting up while spiraling outward. For example, the first few squares are allocated like this:

17  16  15  14  13
18   5   4   3  12
19   6   1   2  11
20   7   8   9  10
21  22  23---> ...

While this is very space-efficient (no squares are skipped), requested data must be carried back to square 1 (the location of the only access port for this memory system) by programs that can only move up, down, left, or right. They always take the shortest path: the Manhattan Distance between the location of the data and square 1.

For example:

    Data from square 1 is carried 0 steps, since it's at the access port.
    Data from square 12 is carried 3 steps, such as: down, left, left.
    Data from square 23 is carried only 2 steps: up twice.
    Data from square 1024 must be carried 31 steps.

How many steps are required to carry the data from the square identified in your puzzle input all the way to the access port?

]#

import math
import rationals

proc solve(n: int): int =
  var
    side = 1
    gridSize = 1  # also the bottom right
  # bottom right (1,9,25,49,81,...)
  # -> same as next odd^2
  # -> same as (2n-1)^2
  # -> same as ceil(sqrt(n))
  while gridSize < n:
    side += 2
    gridSize = side ^ 2
  # find where we are at X and Y axis
  # so we can calculate the manhattan distance
  let
    centerXY = (side + 1) div 2 - 1  # zero indexed
    bottom = gridSize - side + 1
    left = bottom - side + 1
    top = left - side + 1
    # right = top - side + 1
  var
    x = 0
    y = 0
  if bottom <= n:
    x = n - bottom
  elif left <= n:
    y = bottom - n
  elif top <= n:
    x = left - n
  else:  # right
    y = top - n
  # manhattan distance
  return abs(x-centerXY) + abs(y-centerXY)

echo $solve(1)
echo $solve(12)
echo $solve(23)
echo $solve(1024)
echo $solve(368078)
