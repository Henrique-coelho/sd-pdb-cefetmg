usage ()
{
  echo "Usage : Script <pdb_file_path> <res1> <atm1> <res2> <atm2> <cutoff>";
  exit;
}

if [ "$#" -ne 6 ];
then
  usage;
fi

pids=()
max_processos=5 # procurar time de arquitura para definimos qual sera o maximo de instancias possiveis

executar_processo() {
  ./distanceCalculatorFileGenerator.sh $pdb $res1 $atm1 $resn1 $res2 $atm2 $resn2 $cutoff
}

# file path
pdb=$1

# information about interactor 1
res1=$2
atm1=$3

# information about interactor 2
res2=$4
atm2=$5

# candidates optimized form
# for resn1 in `egrep "^ATOM *[0-9]+ *$atm1 *$res1 *A" $1 | awk '{ print substr($0,23,4) }'`; do 
#   for resn2 in `egrep "^ATOM *[0-9]+ *$atm2 *$res2 *A" $1 | awk '{ print substr($0,23,4) }'`; do 
#     ./distanceCalculatorFileGenerator.sh $pdb $res1 $atm1 $resn1 $res2 $atm2 $resn2 $cutoff &
#   done;
# done;


# verificar forma de tentar deixar a execucao em paralelo, para melhorar a perfomance do codigo
# resn1 candidates
vet_resn1=()
for resn1 in `egrep "^ATOM *[0-9]+ *$atm1 *$res1 *A" $1 | awk '{ print substr($0,23,4) }'`; do
  #verifica se o valor nao e nulo para adicionar o valor no vetor
  if [ ! -z "$resn1" ];
  then
    vet_resn1+=($resn1);
  fi
done

#verifica se tem valor no primeiro vetor para executar a verificacao de res2
if [ ${#vet_resn1[@]} -gt 0 ];
then
  # resn2 candidates
  vet_resn2=()
  for resn2 in `egrep "^ATOM *[0-9]+ *$atm2 *$res2 *A" $1 | awk '{ print substr($0,23,4) }'`; do
    #verifica se o valor nao e nulo para adicionar o valor no vetor
    if [ ! -z "$resn2" ];
    then
      vet_resn2+=($resn2);
    fi
  done

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
fi