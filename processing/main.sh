#!/bin/bash

# create table

# get pdb files
# must remove XRAY based pdb file
for file in `grep "EXPERIMENT TYPE" * | grep -v "X-RAY" | cut -d: -f1`; do 
  echo $file; 
  rm -f $file; 
done

# call torance

# call replication