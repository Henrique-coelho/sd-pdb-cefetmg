#!/bin/bash

# Check if the correct number of command-line arguments is provided
if [ $# -ne 4 ]; then
    echo "Usage: $0 <variable1> <variable2> <variable3> <variable4>"
    exit 1
fi

# Set the file_path to "interacoes.csv"
file_path="interacoes.csv"

# Check if the file exists
if [ -f "$file_path" ]; then
    # Read the file and search for the matching line
    while IFS=: read -r var1 var2 var3 var4 rest; do
        # Check if the variables match the provided arguments
        if [[ "$var1" == *"$1"* && "$var2" == *"$2"* && "$var3" == *"$3"* && "$var4" == *"$4"* ]]; then
            # Extract the information after the fourth colon ":"
            information=${rest#*:*:*:*:}

            # Print the information
            echo "$information"
            exit 0
        fi
    done < "$file_path"

    # If no matching line is found
    echo "No matching interaction found for the given variables."
else
    echo "The file $file_path does not exist."
fi
