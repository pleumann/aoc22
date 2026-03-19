#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

for PAS in "$SCRIPT_DIR"/day*/*.pas; do
  if head -1 "$PAS" | grep -qi "^program"; then
    DIR="$(dirname "$PAS")"
    FILE="$(basename "$PAS")"
    echo "=== Building $FILE in $(basename "$DIR") ==="
    (cd "$DIR" && pasta --opt --dep "$FILE")
  fi
done
