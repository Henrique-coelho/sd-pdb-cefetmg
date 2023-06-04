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

# recovering info from the protein and save in new file
# Create the file with the specified name pattern
# order 80, residue LYS, atom NZ
# 80LYS-NZ_81ASN-OD1.ent
filename="${resn1}${res1}-${atm1}_${resn2}${res2}-${atm2}.ent";

#########################################################################
# not working!!!! extractFolderName does not found the interaction name #
# tested with SER OG LYS NZ                                             #
#########################################################################

# ../naming/extractFolderName.sh "$resn1" "$res1" "$resn2" "$res2";
# type_of_interaction=$?;
# pdb_without_extension="${pdb%.ent}";
# path="${pdb_without_extension}/${type_of_interaction}";

# # Create the directory if it doesn't exist
# mkdir -p "$path";

# # Move the file to the directory
# mv "$filename" "$path/$filename";

# egrep "^CRYST1" "$pdb" > "$path/$filename";
# egrep "^SCALE" "$pdb" >> "$path/$filename";
egrep "^CRYST1" "$pdb" > output.txt;
egrep "^SCALE" "$pdb" >> output.txt;

# set numbers of past and future aminoacids related to interactor 1
resn1p=`echo "$resn1-1" | bc`;
resn1f=`echo "$resn1+1" | bc`;

# set numbers of past and future aminoacids related to interactor 2
resn2p=`echo "$resn2-1" | bc`;
resn2f=`echo "$resn2+1" | bc`;

# recovering rows of interactors and theirs related. Then save it
# egrep "^ATOM *[0-9]+ *[A-Z]+[0-9]* *[A-Z]+[0-9]* *A *($resn1p|$resn1|$resn2f|$resn2p|$resn2|$resn2f)" "$pdb" >> "$path/$filename";
egrep "^ATOM *[0-9]+ *[A-Z]+[0-9]* *[A-Z]+[0-9]* *A *($resn1p|$resn1|$resn1f|$resn2p|$resn2|$resn2f) " "$pdb" >> output.txt;

# end of pdb file by default for new interaction file
# echo "END" >> "$path/$filename";
echo "END" >> output.txt;