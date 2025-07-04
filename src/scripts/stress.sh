#!/bin/bash

ITERATIONS=100
SLEEP_SECONDS=1.8

pkexec stress-ng --matrix 0 --ignite-cpu --timeout $((ITERATIONS * SLEEP_SECONDS)) -q &

sleep 2

for ((i=1; i<=ITERATIONS; i++)); do
    temp=$(inxi -s | grep -i "temp" | head -1 | awk '{print $4}')
    echo "$temp"
    sleep $SLEEP_SECONDS
done