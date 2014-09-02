#!/bin/bash

for k in 31 63; do
    for c in 1 2 3 4 5 6 7 8 9 10 20 30 40 50; do
        make NUM_COLS=$c MAXK=$k cortex_var
    done
done
