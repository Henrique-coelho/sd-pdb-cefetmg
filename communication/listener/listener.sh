#!/bin/bash

# Function to receive a message
receive_message() {
    local port=$1
    nc -l -p $port
}

# Function to receive a file
receive_file() {
    local port=$1
    nc -l -p $port > received_file.txt
}

# Function to decrypt a file
# Input parameter = file.txt.gpg
decrypt_file() {
    local file=$1
    file_without_extension="$(egrep "(.+?)(.[^.]*$|$)")"
    gpg --decrypt --output $file_without_extension $file
    echo "File $file decrypted successfully!"
} 

## Abaixo existe apenas um exemplo do uso das funcoes
# # Set the port number for listening
# receiver_port="12345"  # Replace with the port number you want to listen on

# # Receive a message
# received_message=$(receive_message $receiver_port)
# if [ -n "$received_message" ]; then
#     echo "Received message: $received_message"
# else
#     echo "Error: Failed to receive message."
#     exit 1
# fi

# # Receive a file
# receive_file $receiver_port
# if [ $? -eq 0 ]; then
#     echo "File received successfully!"
# else
#     echo "Error: Failed to receive file."
#     exit 1
# fi
