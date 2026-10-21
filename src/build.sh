#!/bin/bash

if [[ "$1" == "--agon" ]]; then
  DIR=agon
  EXT=bin
  SCR=aoc22.obey
  DEL="try delete aoc22.log"
else
  DIR=cpm
  EXT=com
  SCR=aoc22.sub
  DEL="era aoc22.log"
fi

rm -rf $DIR
mkdir $DIR

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

for PAS in "$SCRIPT_DIR"/day*/*.pas; do
  if head -1 "$PAS" | grep -qi "^program"; then
    DAY="$(basename $(dirname $PAS))"
    SRC="$(basename $PAS)"
    OUT="${SRC%.*}"
    echo "=== Building $(basename $DAY) ==="
    pasta80 $1 $PAS
    cp $DAY/$OUT.$EXT $DIR
    cp $DAY/input.txt $DIR/$OUT.txt
  fi
done

pasta80 $1 pause.pas
cp pause.$EXT $DIR

pasta80 $1 check.pas
cp check.$EXT $DIR
cp golden.log $DIR

# Start with a fresh log, so a crashed day can't hide behind an old entry
printf '%s\r\n' "$DEL" > $DIR/$SCR
cat run.txt >> $DIR/$SCR
