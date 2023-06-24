#!/bin/bash

#COMMUNICATION PART
. ../communication/listener/listener.sh

receive_file $receiver_port
if [ $? -eq 0 ]; then
    echo "File received successfully!"
else
    echo "Error: Failed to receive file."
    exit 1
fi