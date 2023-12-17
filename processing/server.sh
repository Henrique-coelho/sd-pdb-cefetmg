#!/bin/bash

# server ip
serverId=$(hostname -I);

. ../communication/sender/sender.sh
. ../communication/listener/listener.sh

pdb_file="4hhb.pdb"; 
res1="SER"; 
atm1="OG"; 
res2="LYS"; 
atm2="NZ"; 
cutoff="500"; 
machine="172.29.71.102";

send_message "$machine" "12345" "$serverId:$pdb_file:$res1:$atm1:$res2:$atm2:$cutoff"; 

./storage.sh "12346";