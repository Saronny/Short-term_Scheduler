#!/bin/bash

# Function to validate the file format
validate_file() {
  local file="$1"
  local line_number=0

  # Reading the file line by line
  while IFS= read -r line; do
    ((line_number++))

    # Check if the line contains three comma-separated values 
    if [[ "$line" =~ ^[^,]+,[^,]+,[^,]+$ ]]; then
      # Split the line into three variables using IFS (Internal Field Separator) also removing carriage return characters
      IFS=',' read -r process_id arrival_time burst_time <<< "$(echo "$line" | tr -d '\r')"

      # Check if arrival time is a number
      if ! [[ "$arrival_time" =~ ^[0-9]+$ ]]; then
        echo "Error: Invalid start time: $arrival_time on line $line_number."
        return 1
      fi

      # Check if burst time is a number
      if ! [[ "$burst_time" =~ ^[0-9]+$ ]]; then
        echo "Error: Invalid execution time: $burst_time on line $line_number."
        return 1
      fi
    else
      echo "Error: Invalid line on line $line_number."
      return 1
    fi
  done < "$file"
}

# Function to simulate round-robin scheduling
simulate_round_robin() {
  local -n process_list=$1
  local time_passed=0

  declare -A processes_time_left
  for process in "${process_list[@]}"; do
    IFS=',' read -r process_id arrival_time burst_time <<< "$process"
    processes_time_left["$process_id"]=$burst_time
  done

  local num_processes=${#processes_time_left[@]}
  local process_keys=(${!processes_time_left[@]})

  while (( num_processes > 0 )); do
    local idle=true
    for ((i=0; i<${#process_list[@]}; i++)); do
      local process_id=${process_list[$i]%%,*}
      local arrival_time=${process_list[$i]#*,}
      arrival_time=${arrival_time%%,*}

      if (( processes_time_left["$process_id"] > 0 && time_passed >= arrival_time )); then
        echo "$time_passed. $process_id is using the CPU"
        processes_time_left["$process_id"]=$((processes_time_left["$process_id"] - 1))
        time_passed=$((time_passed + 1))
        idle=false
        if (( processes_time_left["$process_id"] <= 0 )); then
          echo "$time_passed. Process $process_id terminated"
          unset processes_time_left["$process_id"]
          num_processes=${#processes_time_left[@]}
        fi
      fi
    done
    if [ "$idle" = true ]; then
      echo "$time_passed. idle"
      time_passed=$((time_passed + 1))
    fi
  done
}

# Parse command line options -file file.txt using file parameters
if [ "$1" == "-file" ]; then
  # Check if file is provided
  if [ -z "$2" ]; then
    echo "Error: Input file not provided." >&2
    exit 1
  # Check if file exists 
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

# load the data from the file into an array
processes=($(cat $input_file))
# call the function, passing the name of the array variable
simulate_round_robin processes

