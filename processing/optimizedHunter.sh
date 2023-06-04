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
    ./distanceCalculatorFileGenerator.sh $1 $2 $3 $4 $5 $6 $7 $8
}

there_is_resn2=$false;
there_is_interaction=$false;
for resn1 in `egrep "^ATOM *[0-9]+ *$atm1 *$res1 *A" $pdb | awk '{ print substr($0,23,4) }'`; do
    # in the exemple, there are 24 SER OG in file
    # if $atm1 $res1 not found, the script will not loop second for
    
    for resn2 in `egrep "^ATOM *[0-9]+ *$atm2 *$res2 *A" $pdb | awk '{ print substr($0,23,4) }'`;do
        # in the exemple, so the script must look for LYS NZ 24 times
        # there is no residue elimination, one of then can match with many others
        
        ####################
        # thread wait here #
        ####################

        # if $atm2 $res2 found, script must continue first for
        there_is_resn2=$true
        there_is_interaction=$true;
        
        # executar_processo $pdb $res1 $atm1 $resn1 $res2 $atm2 $resn2 $cutoff
        ./distanceCalculator.sh $pdb $res1 $atm1 $resn1 $res2 $atm2 $resn2 $cutoff
        
    done;

    if [ "$there_is_resn2" -eq "$false" ]; 
    then
        # there is no resn2 applicants, then first for must stop
        break;
    fi
done;
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