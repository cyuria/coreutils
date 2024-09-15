#!/usr/bin/bash

zig build --release=fast

RUNS=100
FILES=$(find /etc -type f -readable 2>/dev/null | head -1000 | tr '\n' ' ')

cat $FILES >/dev/null

for command in '/usr/bin/cat' zig-out/bin/cat
do
    echo "$command"
    time for ((n = 0; n < $RUNS; n++)); do $command $FILES >/dev/null; done
    echo
done
