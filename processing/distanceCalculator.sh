#!/bin/bash

usage ()
{
    echo "Usage : $0 <pdb_file_path> <res1> <atm1> <resn1> <res2> <atm2> <resn2> <cutoff>";
    exit;
}

if [ "$#" -ne 8 ];
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
resn1=$4;

# information about interactor 2
res2=$5;
atm2=$6;
resn2=$7;

# cutoff distance
cutoff=$8;

# recovering related x, y and z
x1=`egrep "^ATOM *[0-9]+ *$atm1 *$res1 *A *$resn1 " $pdb | awk '{ print substr($0,31,8) }'`;
y1=`egrep "^ATOM *[0-9]+ *$atm1 *$res1 *A *$resn1 " $pdb | awk '{ print substr($0,39,8) }'`;
z1=`egrep "^ATOM *[0-9]+ *$atm1 *$res1 *A *$resn1 " $pdb | awk '{ print substr($0,47,8) }'`;
x2=`egrep "^ATOM *[0-9]+ *$atm2 *$res2 *A *$resn2 " $pdb | awk '{ print substr($0,31,8) }'`;
y2=`egrep "^ATOM *[0-9]+ *$atm2 *$res2 *A *$resn2 " $pdb | awk '{ print substr($0,39,8) }'`;
z2=`egrep "^ATOM *[0-9]+ *$atm2 *$res2 *A *$resn2 " $pdb | awk '{ print substr($0,47,8) }'`;

# Euclidean distance
distance=`echo "scale=3;sqrt(($x1-($x2))^2+($y1-($y2))^2+($z1-($z2))^2)" | bc`;

# show info
# echo "The calculated distance between $atm1 $res1 $resn1 x($x1) y($y1) z($z1) and $atm2 $res2 $resn2 x($x2) y($y2) z($z2) = $distance";

# comparing distance with cutoff
there_is_interaction=`echo "$distance<=$cutoff" | bc`;

if [ "$there_is_interaction" -eq "$true" ];
then
    # call file generator to save valid interaction
    ./fileGenerator.sh $pdb $res1 $atm1 $resn1 $res2 $atm2 $resn2 $cutoff
fi
# otherwise, do nothing