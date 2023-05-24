usage ()
{
  echo "Usage : Script <pdb_file_path> <res1> <atm1> <res2> <atm2> <cutoff>";
  exit;
}

if [ "$#" -ne 6 ]
then
  usage;
fi

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

# resn1 candidates
vet_resn1=()
for resn1 in `egrep "^ATOM *[0-9]+ *$atm1 *$res1 *A" $1 | awk '{ print substr($0,23,4) }'`; do 
  vet_resn1+=($resn1);
done;

# resn2 candidates
vet_resn2=()
for resn2 in `egrep "^ATOM *[0-9]+ *$atm2 *$res2 *A" $1 | awk '{ print substr($0,23,4) }'`; do
  vet_resn2+=($resn2);
done;

# find distance and generate valid files
for resn1 in "${vet_resn1[@]}"; do
  for resn2 in "${vet_resn2[@]}"; do
    ./distanceCalculatorFileGenerator.sh $pdb $res1 $atm1 $resn1 $res2 $atm2 $resn2 $cutoff
  done;
done;
