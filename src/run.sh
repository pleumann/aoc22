#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Start with a fresh log, so a crashed day can't hide behind an old entry
rm -f cpm/aoc22.log

for COM in "$SCRIPT_DIR"/day*/*.com; do
  DIR="$(dirname "$COM")"
  BIN="$(basename "$COM")"
  OUT="${BIN%.*}"
  (cd cpm && tnylpo -soy,4,0 -t 3 -y 28,1 $OUT $OUT.txt)
done

(cd cpm && tnylpo -soy -l 30 -t @ check)
