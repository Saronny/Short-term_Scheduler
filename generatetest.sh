#!/bin/bash

# Default number of processes if none is provided
default_processes=10

# Number of processes is the first argument or default
num_processes=${1:-$default_processes}

# Find the next available file name
filename_base="test"
extension=".csv"
counter=1

while true; do
    filename="${filename_base}${counter}${extension}"
    if [[ ! -e $filename ]]; then
        break
    else
        ((counter++))
    fi
done

# Generate the CSV file
for ((i=1; i<=$num_processes; i++))
do
    arrival_time=$((RANDOM%50))
    burst_time=$((RANDOM%10+1))
    echo "P$i,$arrival_time,$burst_time" >> $filename
done

echo "Generated file: $filename with $num_processes processes"
