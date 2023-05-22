usage ()
{
  echo 'Usage : Script <pdb_file_path> <res1> <atm1> <res2> <atm2> <cutoff>';
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

# resn1 candidates
for resn1 in `egrep "^ATOM *[0-9]+ *$atm1 *$res1 *A" $1 | awk '{ print substr($0,23,4) }'`; do 
    echo "$resn1"; 
done;

# resn2 candidates
for resn2 in `egrep "^ATOM *[0-9]+ *$atm2 *$res2 *A" $1 | awk '{ print substr($0,23,4) }'`; do
    echo "$resn2"; 
done;