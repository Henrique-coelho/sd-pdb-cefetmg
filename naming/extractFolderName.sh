#!/bin/bash

# Check if file_path is provided as a command-line argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <file_path>"
    exit 1
fi

# Retrieve the file_path from command-line argument
file_path=$1

# Check if the file exists
if [ -f "$file_path" ]; then
    # Read the first line of the file
    first_line=$(head -n 1 "$file_path")

    # Split the first line into parts based on whitespace
    parts=($first_line)

    # Check if there are enough elements
    if [ ${#parts[@]} -ge 2 ]; then
        # Get the first and second element
        atm1=${parts[0]}
        resn1=${parts[1]}

        # Concatenate the elements to form the folder name
        folder_name="$atm1:$resn1"

        # Use the folder name as needed
        echo "$folder_name"
    else
        echo "The first line of the file does not have enough elements."
    fi
else
    echo "The file $file_path does not exist."
fi
