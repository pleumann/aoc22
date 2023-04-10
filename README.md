# Advent of Code 2022
This repo contains my solutions for [Advent of Code 2022](https://www.adventofcode.com)
in two flavors: Java and Pascal.

## Java ##

These are my original solutions from December 2022, all wrapped into a NetBeans project.
After building, the typical way to run a certain puzzle is (from the project directory):
```
java -cp dist/AdventOfCode22.jar day01.Puzzle src/day01/input.txt
```
Replace the day number (01-25) as needed.

Note that ```input.txt``` contains the input data I received. Yours may (and most
probably will) be different. There will also be at least one ```example.txt``` file
per directory copy-pasted from the puzzle description.

## Pascal ##

All days contain a solution in 
[Pascal](https://en.wikipedia.org/wiki/Pascal_(programming_language)) for 8-bit
[CP/M](https://en.wikipedia.org/wiki/CP/M), as I'm working on a simple Pascal compiler
for [Z80](https://en.wikipedia.org/wiki/Zilog_Z80) in my spare time. There is a
[YouTube Playlist](https://youtube.com/playlist?list=PLcjDDXgGeSQ6E3NLeSOH0Tn7UorYBgUOH)
with videos of those solutions running on a [ZX Spectrum Next](https://www.specnext.com).
If you want to run them yourself and don't have real CP/M machine available, my
recommended CP/M emulator is [tnylpo](https://gitlab.com/gbrein/tnylpo).

Most Pascal solutions started out as straight ports of the Java ones after Advent of Code
was already finished. Only some were done in December already and I did not necessarily do
them "in order" (otherwise the big integer routines developed for day 21 would have seen
more widespread use).

In many cases the CPU (28 MHz!) and memory (64 kB!) limitations of the target system
forced me to rethink my approach. A solution that would use several GB of memory was a
clear no-go from the start. Regarding run-time, the rule-of-thumb I found was that a
second in Java means a minute in tnylpo (both on my MacBook Air M1) and an hour on the
ZX Spectrum Next (which, running at 28 MHz, is already quite fast compared to Z80 systems
from the late 70s or early 80s that would often clock at 3.5 MHz). As a result, many
Pascal solutions are actually much better (from an algorithmic perspective) than the
original Java ones that "got me the stars".

That is, for me, probably the most interesting takeaway of doing this exercise on 8-bit:
The limitations force you to create more efficient solutions, something that often gets
lost in the age of GHz and GB machines.
