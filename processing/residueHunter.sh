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

execute_distance_calculator()
{
    # parameters passed as $# in local scope
    ./distanceCalculator.sh $1 $2 $3 $4 $5 $6 $7 $8 $9 ${10}
}

pdb_without_extension="${pdb%.ent}";
root_path=${pdb_without_extension};
mkdir -p "$root_path";

there_is_resn2=$is_false;
there_is_interaction=$is_false;
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
            wait -n # para aguardar qualquer processo que esta sendo executado em segundo plano seja executado
            for pid in "${pids[@]}"; do # para ir em cada um dos pids e descobrir qual pode ser excluido (no bash, o wait retorna o codigo de saida mas nao o PID finalizado, por isso precisamos percorrer a lista para descobrir qual é)
                if ! kill -0 "$pid" 2>/dev/null; then # O comando kill -0 "$pid" verifica se o processo existe, mas não envia nenhum sinal ao processo. Se o processo não existir mais, o comando kill retornará um status de saída diferente de zero, indicando que o processo foi encerrado.
                    # O comando 2>/dev/null é para direcionar qualquer erro que possa ser dado para o "buraco negro" /dev/null, onde so irá ser descartado e não mostrará no console a mensagem de erro
                    pids=("${pids[@]/$pid}") # Remove o PID do processo concluído do array pids
                fi
            done
            pids=("${pids[@]}") # Remove os elementos vazios do array pids
        done

        # if $atm2 $res2 found, script must continue first for
        there_is_resn2=$is_true;
 
    done;
    if [ "$there_is_resn2" -eq "$is_false" ]; 
    then
        # there is no resn2 applicants, then first for must stop
        break;
    fi
done;

# Wait for any remaining processes to finish
while [ ${#pids[@]} -gt 0 ]; do
    wait -n 
    for pid in "${pids[@]}"; do
        if ! kill -0 "$pid" 2>/dev/null; then 
            # Remove o PID do processo concluído do array pids
            pids=("${pids[@]/$pid}")
        fi
    done
    pids=("${pids[@]}") # Remove os elementos vazios do array pids
done

# find at least one generated file;
there_is_interaction=$(du -s $root_path | awk '{ print $1 }');
if [ "$there_is_interaction" -gt "4" ];
then 
  # if enters here, means that there is at least candidates
  # zip the entire path
  zip -r "$root_path.zip" "$root_path";
fi