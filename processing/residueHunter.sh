#!/bin/bash

usage() {
    echo "Usage : $0 <pdb_file_path> <res1> <atm1> <res2> <atm2> <cutoff>";
    exit;
}

if [ "$#" -ne 6 ]; then
    usage;
fi

max_processes=5 # Architeture team must define max number for process

# boolean
is_false=0;
is_true=1;

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

execute_distance_calculator() {
    # parameters passed as $# in local scope
    # include tolerance
    ./distanceCalculator.sh "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" "${10}"
}

pdb_without_extension="${pdb%.ent}";
root_path="${pdb_without_extension}";
mkdir -p "$root_path";

there_is_resn2=$is_false;
there_is_interaction=$is_false;
for resn1 in $(egrep "^ATOM *[0-9]+ *$atm1 *$res1 *A" "$pdb" | awk '{ print substr($0,23,4) }'); do
    # in the example, there are 24 SER OG in file
    # if $atm1 $res1 not found, the script will not loop second for
    
    for resn2 in $(egrep "^ATOM *[0-9]+ *$atm2 *$res2 *A" "$pdb" | awk '{ print substr($0,23,4) }'); do
        # in the example, so the script must look for LYS NZ 24 times
        # there is no residue elimination, one of them can match with many others
        
        type_of_interaction=$(../naming/extractFolderName.sh "$res1" "$atm1" "$res2" "$atm2");
        path="$root_path/$type_of_interaction";

        # Create the directory if it doesn't exist
        mkdir -p "$path";
        
        # Execute distance calculator
        execute_distance_calculator "$pdb" "$res1" "$atm1" "$resn1" "$res2" "$atm2" "$resn2" "$cutoff" "$path" "$pdb_without_extension" &
        
        # While the number of running processes is equal to or greater than the maximum allowed processes, wait before starting another one
        while [ "$(ps -ef | grep 'distanceCalculator' | wc -l)" -ge "$max_processes" ]; do
            sleep 1 #é para ajudar a evitar um loop infinito consumindo recursos da CPU enquanto espera pelos processos, tipo um intervalo para reduzir um pouco do uso da CPU constante
        done
        
        # if $atm2 $res2 found, script must continue first for
        there_is_resn2=$is_true;
    done
    
    if [ "$there_is_resn2" -eq "$is_false" ]; then
        # there is no resn2 applicants, then first for must stop
        break;
    fi
done

# Wait for any remaining processes to finish
while [ "$(ps -ef | grep 'distanceCalculator' | wc -l)" -gt 1 ]; do
    sleep 1
done

# find at least one generated file;
there_is_interaction=$(du -s "$root_path" | awk '{ print $1 }');
if [ "$there_is_interaction" -gt 4 ]; then 
    # if enters here, means that there is at least candidates
    # zip the entire path
    zip -r "$root_path.zip" "$root_path";
    # Dúvida: Nesse momento já sabemos as informações de conexão com o servidor?
    # ../replication/dump.sh create localhost "MYSQL_USERNAME" "MYSQL_PASSWORD" "DATABASE_NAME";
    # ../replication/send.sh;
fi