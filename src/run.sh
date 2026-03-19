#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

for COM in "$SCRIPT_DIR"/day*/*.com; do
  DIR="$(dirname "$COM")"
  BIN="$(basename "$COM")"
  echo "=== Running $BIN in $(basename "$DIR") ==="
  (cd "$DIR" && tnylpo -soy,4,0 -t 3 -y 28,1 "$BIN" input.txt)
done
