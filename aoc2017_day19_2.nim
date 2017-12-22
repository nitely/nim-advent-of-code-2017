#[
--- Part Two ---

The packet is curious how many steps it needs to go.

For example, using the same routing diagram from the example above...

     |
     |  +--+
     A  |  C
 F---|--|-E---+
     |  |  |  D
     +B-+  +--+

...the packet would go:

    6 steps down (including the first line at the top of the diagram).
    3 steps right.
    4 steps up.
    3 steps right.
    4 steps down.
    3 steps right.
    2 steps up.
    13 steps left (including the F it stops on).

This would result in a total of 38 steps.

How many steps does the packet need to go?

]#

import strutils

type
  Direction = enum
    dirUp,
    dirDown,
    dirLeft,
    dirRight

proc solve(s: string): int =
  var grid = newSeqOfCap[string](s.countLines)
  for r in s.split("\n"):
    grid.add(r)
  var
    row = 0
    col = grid[row].find("|")
    dir = dirDown
  assert col != -1
  while grid[row][col] != ' ':
    inc result
    if grid[row][col] == '+':
      dir = case dir:
      of dirUp, dirDown:
        if grid[row][col+1] != ' ':
          dirRight
        else:
          dirLeft
      of dirLeft, dirRight:
        if grid[row-1][col] != ' ':
          dirUp
        else:
          dirDown
    case dir:
    of dirUp:
      dec row
    of dirDown:
      inc row
    of dirLeft:
      dec col
    of dirRight:
      inc col

echo solve(readFile("./aoc2017_day19_sample.txt"))
echo solve(readFile("./aoc2017_day19.txt"))
