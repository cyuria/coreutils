#!/usr/bin/bash

zig build

RUNS=500
FILE=$(find -type f /etc)

cat $FILES >/dev/null
echo "GNU cat:"
time for ((n = 0; n < $RUNS; n++)); do /usr/bin/cat $FILES >/dev/null; done 2>&1
echo
echo "wcutils cat:"
time for ((n = 0; n < $RUNS; n++)); do zig-out/bin/cat $FILES >/dev/null; done 2>&1
