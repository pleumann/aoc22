#/bin/bash

puzzle() {
  java -Xmx4096M -Xss1024M -cp dist/AdventOfCode22.jar day${1}.Puzzle src/day${1}/${2}
}

if [ "$1" == "" ]
then
  echo "Usage: ./aoc24.sh <day> [<input>]"
  exit
fi

if [ "$2" == "" ]
then
  INPUT="input.txt"
else
  INPUT="$2"
fi

if [ "$1" == "--all" ]
then
  for i in $(seq -f "%02g" 1 25);
  do
    puzzle $i $INPUT
  done
else
  puzzle "$1" $INPUT
fi
