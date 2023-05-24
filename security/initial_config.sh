#!/bin/sh

# Check if GnuPG is installed
if ! command -v gpg &> /dev/null; then
    echo "GnuPG is not installed. Please install it first."
    exit 1
fi

# Create a secret-key 
generate_key(){
    echo "Creating a GnuPG key."
    gpg --generate-key
    # echo "sd" #name
    # echo "sd@exe.com" #email
    # echo "o" #OK
    #sendfile $file-key #by communication code
}

# generate_key
