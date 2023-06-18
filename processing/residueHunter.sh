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
    ./distanceCalculator.sh $1 $2 $3 $4 $5 $6 $7 $8 $9 ${10}
}

pdb_without_extension="${pdb%.ent}";
root_path=${pdb_without_extension};
mkdir -p "$root_path";

there_is_resn2=$false;
there_is_interaction=$false;
for resn1 in `egrep "^ATOM *[0-9]+ *$atm1 *$res1 *A" $pdb | awk '{ print substr($0,23,4) }'`; do
    # in the exemple, there are 24 SER OG in file
    # if $atm1 $res1 not found, the script will not loop second for
    
    for resn2 in `egrep "^ATOM *[0-9]+ *$atm2 *$res2 *A" $pdb | awk '{ print substr($0,23,4) }'`;do
        # in the exemple, so the script must look for LYS NZ 24 times
        # there is no residue elimination, one of then can match with many others
        
        type_of_interaction=`../naming/extractFolderName.sh "$res1" "$atm1" "$res2" "$atm2"`;
        path="$root_path/$type_of_interaction";

        # Create the directory if it doesn't exist
        mkdir -p "$path";
        
        # Execute distance calculator
        execute_distance_calculator $pdb $res1 $atm1 $resn1 $res2 $atm2 $resn2 $cutoff $path $pdb_without_extension &
        pids+=($!)
        
        # While pids for equals or greater then the maximum allowed process, wait to call another one
        while [ ${#pids[@]} -ge $max_processes ]; do
            wait
        done

        # if $atm2 $res2 found, script must continue first for
        there_is_resn2=$true;
 
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

# find at least one generated file;
there_is_interaction=$(du -s $root_path | awk '{ print $1 }');
if [ "$there_is_interaction" -gt "4" ];
then
    echo "there is file";
    echo "ZIP";
    # if enters here, means that there is at least candidates

  #verifica se tem dado no vetor de resn2 para poder realizar o calculo de distancia
  if [ ${#vet_resn2[@]} -gt 0 ]; then
  # find distance and generate valid files
  for resn1 in "${vet_resn1[@]}"; do
    for resn2 in "${vet_resn2[@]}"; do
      executar_processo &
      pids+=($!)
      # enquanto o numero de pids for igual ou maior que o maximo de processos permitidos, ele vai aguardar ate que algum processo termine, para que possa incluir um novo processo
      while [ ${#pids[@]} -ge max_processos ]; do
        wait
      done
    done
  done

  # Wait for any remaining processes to finish ( aqui é para quando sair do for, para garantir que todos os pids terminaram de executar antes de continuar o codigo )
  while [ ${#pids[@]} -gt 0 ]; do
    wait
  done
  fi
  # zip the entire path
  zip -r "$root_path.zip" "$root_path";
fi