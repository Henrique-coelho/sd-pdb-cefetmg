#!/bin/sh

# Check if GnuPG is installed
#if ! command -v gpg &> /dev/null; then
#    echo "GnuPG is not installed. Please install it first."
#    exit 1
#fi

# Create a Keydatails File
generate_key_file(){
    systemID=$1
    echo $systemID
    cat > keydetails.txt << EOF
    Key-Type: RSA
    Key-Length: 2048
    Name-Real: $systemID
    Name-Email: $systemID@sd.com
    Expire-Date: 0
    %no-ask-passphrase
    %no-protection
EOF
    echo "Key File created."
}

# Create a secret-key 
generate_key(){
    systemID=$1
    echo "Creating a GnuPG key."
    generate_key_file $systemID
    gpg --batch --gen-key keydetails.txt
    #sendfile $file-key #by communication code
}

generate_key "192.168.0.1"
