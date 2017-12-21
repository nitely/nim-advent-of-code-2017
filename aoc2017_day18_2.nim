#[
--- Part Two ---

As you congratulate yourself for a job well done, you notice that the documentation has been on the back of the tablet this entire time. While you actually got most of the instructions correct, there are a few key differences. This assembly code isn't about sound at all - it's meant to be run twice at the same time.

Each running copy of the program has its own set of registers and follows the code independently - in fact, the programs don't even necessarily run at the same speed. To coordinate, they use the send (snd) and receive (rcv) instructions:

    snd X sends the value of X to the other program. These values wait in a queue until that program is ready to receive them. Each program has its own message queue, so a program can never receive a message it sent.
    rcv X receives the next value and stores it in register X. If no values are in the queue, the program waits for a value to be sent to it. Programs do not continue to the next instruction until they have received a value. Values are received in the order they are sent.

Each program also has its own program ID (one 0 and the other 1); the register p should begin with this value.

For example:

snd 1
snd 2
snd p
rcv a
rcv b
rcv c
rcv d

Both programs begin by sending three values to the other. Program 0 sends 1, 2, 0; program 1 sends 1, 2, 1. Then, each program receives a value (both 1) and stores it in a, receives another value (both 2) and stores it in b, and then each receives the program ID of the other program (program 0 receives 1; program 1 receives 0) and stores it in c. Each program now sees a different value in its own copy of register c.

Finally, both programs try to rcv a fourth time, but no data is waiting for either of them, and they reach a deadlock. When this happens, both programs terminate.

It should be noted that it would be equally valid for the programs to run at different speeds; for example, program 0 might have sent all three values and then stopped at the first rcv before program 1 executed even its first instruction.

Once both of your programs have terminated (regardless of what caused them to do so), how many times did program 1 send a value?

]#

# I'm using iterators for multi-thread simulation,
# so it manage the thread local state

import strutils
import deques

type
  DequeRef[T] = ref Deque[T]
  Thread = tuple
    id: int
    sq: DequeRef[int]
    rq: DequeRef[int]
    it: iterator: void

proc newDequeRef[T](): DequeRef[T] =
  new result
  result[] = initDeque[T]()

proc toReg(s: string): int =
  s[0].ord - 'a'.ord

proc worker(
      insts: seq[seq[string]],
      id: int,
      sq: DequeRef[int],
      rq: DequeRef[int]
    ): iterator =
  var
    regs = newSeq[int]('z'.ord - 'a'.ord)
    i = 0
  regs["p".toReg] = id
  result = iterator =
    while i < insts.len:
      let
        op = insts[i][0]
        reg = insts[i][1].toReg
      var val = 0
      if insts[i].len >= 3:
        if insts[i][2][0] in 'a' .. 'z':
          val = regs[insts[i][2].toReg]
        else:
          val = insts[i][2].parseInt
      var regVal = 0
      if insts[i][1][0] in 'a' .. 'z':
        regVal = regs[insts[i][1].toReg]
      else:
        regVal = insts[i][1].parseInt
      case op
        of "set": regs[reg] = val
        of "add": regs[reg].inc(val)
        of "mul": regs[reg] = regs[reg] * val
        of "mod": regs[reg] = regs[reg] mod val
        of "snd": sq[].addLast(regVal)
        of "rcv":
          if rq[].len == 0:
            yield  # block
          regs[reg] = rq[].popFirst()
        of "jgz":
          if regVal > 0:
            i.inc(val)
            dec i
        else: doAssert(false, op)
      inc i

proc solve(s: string): int =
  var insts: seq[seq[string]] = @[]
  for line in s.split("\n"):
    insts.add(line.split(' '))
  var
    q1 = newDequeRef[int]()
    q2 = newDequeRef[int]()
    threads = @[
      (id: 0, sq: q1, rq: q2, it: worker(insts, 0, q1, q2)),
      (id: 1, sq: q2, rq: q1, it: worker(insts, 1, q2, q1))]
  # since there are just 2 threads there's
  # no point in using a queue for them
  while true:
    threads[0].it()
    if threads[0].id == 1:
      result.inc(threads[0].sq[].len)
    # can next thread run?
    if threads[1].it.finished or threads[1].rq[].len == 0:
      break
    swap(threads[0], threads[1])

echo solve("""snd 1
snd 2
snd p
rcv a
rcv b
rcv c
rcv d""")
echo solve("""set i 31
set a 1
mul p 17
jgz p p
mul a 2
add i -1
jgz i -2
add a -1
set i 127
set p 316
mul p 8505
mod p a
mul p 129749
add p 12345
mod p a
set b p
mod b 10000
snd b
add i -1
jgz i -9
jgz a 3
rcv b
jgz b -1
set f 0
set i 126
rcv a
rcv b
set p a
mul p -1
add p b
jgz p 4
snd a
set a b
jgz 1 3
snd b
set f 1
add i -1
jgz i -11
snd a
jgz f -16
jgz a -19""")
