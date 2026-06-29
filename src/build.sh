#!/bin/bash

if [[ "$1" == "--agon" ]]; then
  DIR=agon
  EXT=bin
  SCR=aoc22.obey
else
  DIR=cpm
  EXT=com
  SCR=aoc22.sub
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
    pasta --opt --dep $1 $PAS
    cp $DAY/$OUT.$EXT $DIR
    cp $DAY/input.txt $DIR/$OUT.txt
  fi
done

pasta --opt --dep $1 pause.pas
cp pause.$EXT $DIR

cp run.txt $DIR/$SCR
