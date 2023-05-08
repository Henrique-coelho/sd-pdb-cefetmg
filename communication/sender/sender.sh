#!/bin/bash

# Function to send a message
send_message() {
    local ip=$1
    local port=$2
    local message=$3
    echo "$message" | nc -q 0 -N $ip $port
}

# Function to send a file
send_file() {
    local ip=$1
    local port=$2
    local file=$3
    if [ ! -f $file ]; then
        echo "Error: File '$file' does not exist."
        exit 1
    fi
    nc -q 0 -N $ip $port < $file
    echo "File '$file' sent successfully."
}

## Abaixo existe apenas um exemplo do uso das funcoes
# # Get receiver's IP address and port number
# receiver_ip="192.168.1.2"  # Replace with receiver's IP address
# receiver_port="12345"     # Replace with receiver's port number

# # Send a message
# send_message $receiver_ip $receiver_port "Hello, this is a test message from Machine 1!"

# # Send a file
# send_file $receiver_ip $receiver_port "file.txt"  # Replace with the path of the file you want to send
