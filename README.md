# Advent of Code 2022
This repo contains my solutions for [Advent of Code 2022](https://www.adventofcode.com)
in two flavors: Java and Pascal.

## Java ##

These are my original solutions from December 2022, all wrapped into a NetBeans project.
After building, the typical way to run a certain puzzle is (from the project directory):
```
java -cp dist/AdventOfCode22.jar day01.Puzzle src/day01/input.txt
```
Replace the day (01-25) number as needed.

Note that ```input.txt``` contains the input data I received. Yours may (and most
probably will) be different.
Each day usually also contains at least one ```example.txt``` file that contains the
explanatory example from puzzle description.

## Pascal ##

All days also contain a solution in 
[Pascal](https://en.wikipedia.org/wiki/Pascal_(programming_language)) for 8-bit
[CP/M](https://en.wikipedia.org/wiki/CP/M), as I'm working on a simple Pascal compiler
for [Z80](https://en.wikipedia.org/wiki/Zilog_Z80) in my spare time. There is a
[YouTube Playlist](https://youtube.com/playlist?list=PLcjDDXgGeSQ6E3NLeSOH0Tn7UorYBgUOH)
with videos of those solutions running on a [ZX Spectrum Next](https://www.specnext.com).
If you want to run them yourself and you don't have real CP/M machine available, my
recommended CP/M emulator is [tnylpo](https://gitlab.com/gbrein/tnylpo).

Most Pascal solutions started out as straight ports of the Java ones after Advent of Code
was already finished. Only some were done in December already and I did not necessarily do
them "in order" (otherwise the big integer routines developed for day 21 would have seen
more widespread use).

In many cases the CPU (28 MHz!) and memory (64 kB!) limitations of the target system
forced me to rethink my approach. A solution that would use several GB of memory was a
clear no-go from the start. Regarding run-time, my rule-of-thumb was that a second in Java
means an hour on the ZX Spectrum Next (which is already quite fast with its 28 MHz). So,
as a result, many Pascal solutions are actually much better (from an algorithmic
perspective) than the original Java ones that "got me the stars".

That is, for me, probably the most interesting takeaway of doing this exercise on 8-bit:
The limitations force you to create more efficient solutions, something that often gets
lost in the age of GHz and GB machines.
