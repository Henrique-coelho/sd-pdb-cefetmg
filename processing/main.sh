#!/bin/bash

# gpg key
../security/initialConfig.sh

# create table
../architecture/createTables.sh

# execute backup after n minutes? (cronjob)

# get pdb files
../communication/downloader/downloader.sh # <file_code> /proteins

# must remove XRAY based pdb file
for file in `grep "EXPERIMENT TYPE" * | cut -d: -f1`; do   
    if [ "$file" != "main.sh" ]; then
        if [ "`grep "X-RAY" $file | cut -d: -f1`" ]; then
            echo $file; 
        else
            rm -f $file;
        fi
    fi
done

# call torance
../tolerancia/moduloTolerancia.sh # <param>

# call replication (cronjob)
../replication/dump.sh # <param>