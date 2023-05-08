#!/bin/bash

# Exemplos de usos de todas as funções de Comunicação

# Exemplos de download
. downloader.downloader.sh

download_file '4hhb' '/home/aluno/Documentos/sd/downloader/4hhb.pdb'

get_protein_ids
echo $protein_ids


# Exemplos de listener
. listener.listener.sh

receiver_port="12345"
received_message=$(receive_message $receiver_port)
if [ -n "$received_message" ]; then
    echo "Received message: $received_message"
else
    echo "Error: Failed to receive message."
    exit 1
fi

receiver_port="12345"
receive_file $receiver_port
if [ $? -eq 0 ]; then
    echo "File received successfully!"
else
    echo "Error: Failed to receive file."
    exit 1
fi


# Exemplos de sender
. sender.sender.sh

receiver_ip="192.168.1.2"
receiver_port="12345"
send_message $receiver_ip $receiver_port "Hello, this is a test message from Machine 1!"

receiver_ip="192.168.1.2"
receiver_port="12345"
send_file $receiver_ip $receiver_port "file.txt"