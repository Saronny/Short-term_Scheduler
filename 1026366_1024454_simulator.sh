#!/bin/bash

# Student Names: Mike Dudok (1026366), Timo van der Ven (1024454)

input_file=""

# Parse command line options
while getopts ":f:" opt; do
  case $opt in
    f)
      input_file=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# Check if the input file is provided and is a file
if [ -z "$input_file" ]; then
  echo "Error: Input file not provided." >&2
  exit 1
elif [ ! -f "$input_file" ]; then
  echo "Error: $input_file is not a valid file." >&2
  exit 1
fi


# Example usage
echo "Input file: $input_file"



 