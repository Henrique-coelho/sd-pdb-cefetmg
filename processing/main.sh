#!/bin/bash

# COMUNICATION PART
. ../communication/listener/listener.sh
receive_message "12345"
message=$?
# echo "main start";
# echo "$message";

# message="172.21.0.1:4hhb:SER:OG:LYS:NZ:500"

IFS=':' read -r serverId pdb_file res1 atm1 res2 atm2 cutoff <<< "$message"

# gpg key
../security/initialConfig.sh

# create table
../architecture/createTables.sh

# execute backup after n minutes? (cronjob)

# get pdb files
. ../communication/downloader/downloader.sh # <file_code> /proteins

#Conferir sintaxe no path de save
download_file $pdb_file "../pdb_files/${pdb_file}.pdb"

#só pra garantir download
sleep 1

# must remove XRAY based pdb file (pasta pdb_files)
for file in `grep "EXPERIMENT TYPE" ../pdb_files/* | cut -d: -f1`; do   
    if [ "$file" != "main.sh" ]; then
        if [ "`grep "X-RAY" $file | cut -d: -f1`" ]; then
            echo $file; 
        else
            rm -f $file;
        fi
    fi
done

echo "ok"

# # call torance
../tolerancy/insertTask.sh ./processing/residueHunter.sh "../pdb_files/$pdb_file" $res1 $atm1 $res2 $atm2 $cutoff
# ./residueHunter.sh "../pdb_files/${pdb_file}" $res1 $atm1 $res2 $atm2 $cutoff
fileZip = "${pdb_file}.zip"


# # call replication (cronjob)
../replication/dump.sh # <param>

# call to storage
. ../communication/sender/sender.sh
    #usando outra porta para enviar o arquivo
send_file serverId "12346" $fileZip