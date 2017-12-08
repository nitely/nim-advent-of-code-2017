#[
--- Part Two ---

Out of curiosity, the debugger would also like to know the size of the loop: starting from a state that has already been seen, how many block redistribution cycles must be performed before that same state is seen again?

In the example above, 2 4 1 2 is seen again after four cycles, and so the answer in that example would be 4.

How many cycles are in the infinite loop that arises from the configuration in your puzzle input?

]#

# Same as previous part, except it returns the lambda

import strutils
import sets
import hashes

type
  Blocks = seq[int]

proc floyd[N](f: (proc(result: var N)), x0: N): (int, int) =
  ## Floyd's Tortoise and Hare
  ## for finding cycles
  var tortoise = x0;f(tortoise)
  var hare = x0;f(hare);f(hare)
  while tortoise != hare:
    f(tortoise)
    f(hare);f(hare)

  var mu = 0
  tortoise = x0
  while tortoise != hare:
    f(tortoise)
    f(hare)
    inc mu

  var lam = 1
  hare = tortoise;f(hare)
  while tortoise != hare:
    f(hare)
    inc lam

  return (lam, mu)

proc realloc(result: var Blocks) =
  ## in-place reallocation
  let
    maxIdx = result.find(result.max)
    c = result[maxIdx]
  result[maxIdx] = 0
  for i in 1 .. c:
    inc result[(maxIdx + i) %% result.len]

proc solve(n: string): int =
  var blocksSize = 0
  for rb in n.split('\t'):
    inc blocksSize
  var
    blocks = newSeq[int](blocksSize)
    ib = 0
  for rb in n.split('\t'):
    blocks[ib] = rb.parseInt
    inc ib
  # the actual solution
  let (lam, mu) = floyd(realloc, blocks)
  result = lam

echo $solve("0	2	7	0")
echo $solve("11	11	13	7	0	15	5	5	4	4	1	1	7	1	15	11")
