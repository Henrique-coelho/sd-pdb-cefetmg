#!/bin/bash

# server ip
serverId=$(hostname -I);

. ../communication/sender/sender.sh

pdb_file="perguntar qual eh ao usuario"; 
res1="perguntar qual eh ao usuario"; 
atm1="perguntar qual eh ao usuario"; 
res2="perguntar qual eh ao usuario"; 
atm2="perguntar qual eh ao usuario"; 
cutoff="perguntar qual eh ao usuario"; 

send_message "$(hostname -I)" "12345" "$serverId:$pdb_file:$res1:$atm1:$res2:$atm2:$cutoff"; 