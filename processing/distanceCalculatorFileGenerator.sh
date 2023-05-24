#!/bin/bash

# pdb="pdb1bm0.ent"
# res1="LYS"
# atm1="NZ"
# resn1="16"
# res2="SER"
# atm2="OG"
# resn2="8"
# cutoff=1

usage ()
{
  echo 'Usage : Script <pdb_file_path> <res1> <atm1> <resn1> <res2> <atm2> <resn2> <cutoff>';
  exit;
}

if [ "$#" -ne 8 ];
then
  usage;
fi

# file path and name
pdb=$1

# information about interactor 1
res1=$2
atm1=$3
resn1=$4

# information about interactor 2
res2=$5
atm2=$6
resn2=$7

# cutoff distance
cutoff=$8

# recovering related x, y and z 
x1=`egrep "^ATOM *[0-9]+ *$atm1 *$res1 *A *$resn1 " $pdb | awk '{ print substr($0,31,8) }'`
y1=`egrep "^ATOM *[0-9]+ *$atm1 *$res1 *A *$resn1 " $pdb | awk '{ print substr($0,39,8) }'`
z1=`egrep "^ATOM *[0-9]+ *$atm1 *$res1 *A *$resn1 " $pdb | awk '{ print substr($0,47,8) }'`
x2=`egrep "^ATOM *[0-9]+ *$atm2 *$res2 *A *$resn2 " $pdb | awk '{ print substr($0,31,8) }'`
y2=`egrep "^ATOM *[0-9]+ *$atm2 *$res2 *A *$resn2 " $pdb | awk '{ print substr($0,39,8) }'`
z2=`egrep "^ATOM *[0-9]+ *$atm2 *$res2 *A *$resn2 " $pdb | awk '{ print substr($0,47,8) }'`

# Euclidean distance calculation
distance=`echo "scale=3;sqrt(($x1-($x2))^2+($y1-($y2))^2+($z1-($z2))^2)" | bc`

# show info
echo "A distância entre $res1 $atm1 $resn1 x($x1), y($y1), z($z1) e $res2 $atm2 $resn2 x($x2), y($y2), z($z2) = $distance"

# comparing distance with cutoff

#daqui para baixo foi o que o grupo entendeu que deveria ser o gera arquivo
sim=`echo "$distance<=$cutoff" | bc`
if [ $sim -eq 1 ]; then
  # there's interaction
  echo "$distance <= $cutoff";

  # recovering info from the protein and save in new file
  # Create the file with the specified name pattern
  # Ordem 80, resíduo LYS, átomo NZ
  # 80LYS-NZ_81ASN-OD1.ent
  filename="${resn1}${res1}-${atm1}_${resn2}${res2}-${atm2}.ent"

  egrep "^CRYST1" $pdb > $filename;
  egrep "^SCALE" $pdb >> $filename;

  # set numbers of past and future aminoacids related to interactor 1
  resn1p=`echo "$resn1-1" | bc`;
  resn1f=`echo "$resn1+1" | bc`;

  # set numbers of past and future aminoacids related to interactor 2
  resn2p=`echo "$resn2-1" | bc`;
  resn2f=`echo "$resn2+1" | bc`;

  # recovering rows of interactors and theirs related. Then save it
  egrep "^ATOM *[0-9]+ *[A-Z]+[0-9]* *[A-Z]+[0-9]* *A *($resn1p|$resn1|$resn2f|$resn2p|$resn2|$resn2f)" $pdb >> $filename;

  # end of pdb file by default for new interaction file
  echo "END" >> $filename;
else
  # there's no interaction
  echo "$distance > $cutoff";
fi
