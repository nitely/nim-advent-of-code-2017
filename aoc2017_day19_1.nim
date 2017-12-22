#[
--- Day 19: A Series of Tubes ---

Somehow, a network packet got lost and ended up here. It's trying to follow a routing diagram (your puzzle input), but it's confused about where to go.

Its starting point is just off the top of the diagram. Lines (drawn with |, -, and +) show the path it needs to take, starting by going down onto the only line connected to the top of the diagram. It needs to follow this path until it reaches the end (located somewhere within the diagram) and stop there.

Sometimes, the lines cross over each other; in these cases, it needs to continue going the same direction, and only turn left or right when there's no other option. In addition, someone has left letters on the line; these also don't change its direction, but it can use them to keep track of where it's been. For example:

     |
     |  +--+
     A  |  C
 F---|----E|--+
     |  |  |  D
     +B-+  +--+

Given this diagram, the packet needs to take the following path:

    Starting at the only line touching the top of the diagram, it must go down, pass through A, and continue onward to the first +.
    Travel right, up, and right, passing through B in the process.
    Continue down (collecting C), right, and up (collecting D).
    Finally, go all the way left through E and stopping at F.

Following the path to the end, the letters it sees on its path are ABCDEF.

The little packet looks up at you, hoping you can help it find the way. What letters will it see (in the order it would see them) if it follows the path? (The routing diagram is very wide; make sure you view it without line wrapping.)

]#

# There is a more elegant solution using complex numbers, see:
# https://www.reddit.com/r/adventofcode/comments/7kr2ac/2017_day_19_solutions/

import strutils

type
  Direction = enum
    dirUp,
    dirDown,
    dirLeft,
    dirRight

proc solve(s: string): string =
  result = ""
  var grid = newSeqOfCap[string](s.countLines)
  for r in s.split("\n"):
    grid.add(r)
  var
    row = 0
    col = grid[row].find("|")
    dir = dirDown
  assert col != -1
  while grid[row][col] != ' ':
    if grid[row][col] in 'A' .. 'Z':
      result.add(grid[row][col])
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
