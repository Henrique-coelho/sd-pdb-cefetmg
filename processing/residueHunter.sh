#!/bin/bash

usage()
{
    echo "Usage : $0 <pdb_file_path> <res1> <atm1> <res2> <atm2> <cutoff>";
    exit;
}

if [ "$#" -ne 6 ];
then
    usage;
fi

pids=()
max_processes=5 # Architeture team must define max number for process

# boolean
false=0;
true=1;

# file path
pdb=$1;

# information about interactor 1
res1=$2;
atm1=$3;

# information about interactor 2
res2=$4;
atm2=$5;

# cutoff distance
cutoff=$6;

execute_distance_calculator()
{
    # parameters passed as $# in local scope
    ./distanceCalculator.sh $1 $2 $3 $4 $5 $6 $7 $8
}

there_is_resn2=$false;
there_is_interaction=$false;
for resn1 in `egrep "^ATOM *[0-9]+ *$atm1 *$res1 *A" $pdb | awk '{ print substr($0,23,4) }'`; do
    # in the exemple, there are 24 SER OG in file
    # if $atm1 $res1 not found, the script will not loop second for
    
    for resn2 in `egrep "^ATOM *[0-9]+ *$atm2 *$res2 *A" $pdb | awk '{ print substr($0,23,4) }'`;do
        # in the exemple, so the script must look for LYS NZ 24 times
        # there is no residue elimination, one of then can match with many others
        
        # Execute distance calculator
        execute_distance_calculator $pdb $res1 $atm1 $resn1 $res2 $atm2 $resn2 $cutoff &
        pids+=($!)
        
        # While pids for equals or greater then the maximum allowed process, wait to call another one
        while [ ${#pids[@]} -ge $max_processes ]; do
            wait
        done

        # if $atm2 $res2 found, script must continue first for
        there_is_resn2=$true;

        ############# to do: count generated tail files;
        there_is_interaction=$true; 
    done;
    if [ "$there_is_resn2" -eq "$false" ]; 
    then
        # there is no resn2 applicants, then first for must stop
        break;
    fi
done;

# Wait for any remaining processes to finish
for pid in "${pids[@]}"; do
    wait "$pid"
done

if [ "$there_is_interaction" -eq "$true" ];
then
    echo "ZIP";
    # if enters here, means that there is at least candidates
    # there is the empty directory problem

    ################################
    # this part needs improvements #
    ################################

    # zip the entire path
    # zip -r "$path.zip" "$path";
fi