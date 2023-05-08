#!/bin/bash

# Function to download a file from pdb using wget
# Arguments:
# $1 - ProteinCode: The ID of the protein on pdb database.
# $2 - Destination: The local file path where the downloaded file will be saved
function download_file() {
    
    if [[ $# -ne 2 ]]; then
        echo "Usage: download_file <proteinCode> <Destination>"
        return 1
    fi

    local url="https://files.rcsb.org/download/"
    local protein="$1"
    local destination="$2"
    local url+=$protein
    local url+=".pdb"

    echo "Downloading file from URL: $url"
    echo "Protein ID: $protein"
    echo "Saving to: $destination"

    # Download the file using wget
    wget -q "$url" -O "$destination"

    if [[ $? -eq 0 ]]; then
        echo "File downloaded successfully!"
        return 0
    else
        echo "Failed to download file. Exiting..."
        return 1
    fi
}

# Function to return all protein IDs in an array
# Arguments: No argument needed
# Usage: when called, will set a global variable "protein_ids" to the result
function get_protein_ids() {

    local url="https://data.rcsb.org/rest/v1/holdings/current/entry_ids"

    echo "Downloading proteins from URL: $url"

    # Download the file using wget
    wget -q $url
	protein_ids=`cat entry_ids`
    echo "Proteins fetched!"
	rm -f entry_ids
    
}

#Usage of download file function
#download_file '4hhb' '/home/aluno/Documentos/sd/downloader/4hhb.pdb'

#Usage of get protein ids function
#get_protein_ids
#echo $protein_ids
