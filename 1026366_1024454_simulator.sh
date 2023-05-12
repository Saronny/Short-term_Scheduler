#!/bin/bash
# Student Names: Mike Dudok (1026366), Timo van der Ven (1024454)

input_file=""

# Function to validate the file format
validate_file() {
  local file="$1"
  local line_number=0

  while IFS= read -r line; do
    ((line_number++))

    # Check if the line contains three comma separated values
    if [[ "$line" =~ ^[^,]+,[^,]+,[^,]+$ ]]; then
      # Split the line into three variables
      IFS=',' read -r process_id arrival_time burst_time <<< "$line"
      
      #Check if arrival time is a number
      if ! [[ "$arrival_time" =~ ^[0-9]+$ ]]; then
        echo "Error: Invalid start time: $arrival_time on line $line_number." 
        return 1
      fi
      
      #Check if burst time is a number
      if ! [[ "$burst_time" =~ ^[0-9]+$ ]]; then
        echo $burst_time
        echo "Error: Invalid burst time: $burst_time on line $line_number." 
        return 1
      fi

    else 
      echo "Error: Invalid line on line $line_number." 
      return 1
    fi
  done < "$file"
}

# Parse command line options -file file.txt using file parameters
if [ "$1" == "-file" ]; then
  # check if file is provided
  if [ -z "$2" ]; then
    echo "Error: Input file not provided." >&2
    exit 1
  elif [ ! -f "$2" ]; then
    echo "Error: $2 is not a valid file." >&2
    exit 1
  fi
  input_file=$2
else
  echo "Error: -file flag was not set." >&2
  exit 1
fi


validate_file "$input_file"

# Example usage
echo "Input file: $input_file"



 