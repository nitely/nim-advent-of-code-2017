# the other solution is O(1), this one is O(n).
# after seeing the part2 I realized this is how it was meant to be solved (probably)
# it walks through the spiral keeping the distance from center
# the manhattan distance can be calculated from this but meh

import math
import rationals

proc solve(n: int): int =
  var
    x = 0
    y = 0
    steps = 0
    square = 1
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
        inc square
        if square >= n:
          return abs(x) + abs(y)
    inc(steps, 2)

echo $solve(1)
echo $solve(12)
echo $solve(23)
echo $solve(1024)
echo $solve(368078)
