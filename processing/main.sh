#!/bin/bash

# create table

# get pdb files
# must remove XRAY based pdb file
for file in `grep "EXPERIMENT TYPE" * | cut -d: -f1`; do   
    if [ "$file" != "main.sh" ]; then
        if [ "`grep "X-RAY" $file | cut -d: -f1`" ]; then
            echo $file; 
            rm -f $file;
        fi
    fi
done

# call torance

# call replication