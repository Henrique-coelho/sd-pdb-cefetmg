#!/bin/bash

#conversar melhor com o grupo de namming para entender melhor o que foi proposto para que pudessemos relacionar as ideias
if [ $# -lt 8 ]
then echo "Ops! Deu ruim!" 
	echo "Sintaxe:\n$0 ResNumb1 ResNumb2 ResNumb3 ResNumb4 ResNumb5 ResNumb6 PDBFile InteractionFile\n\n"
	exit
fi
pdb=$7
interactFile=$8
egrep "^CRYST1" $pdb > $interactFile
egrep "^SCALE" $pdb >> $interactFile
egrep "^ATOM *[0-9]+ *[A-Z]+[0-9]* *[A-Z]+[0-9]* *B *($1|$2|$3|$4|$5|$6) " $pdb >> $interactFile
echo "END" >> $interactFile

#./executaInterrompendo.sh
#./executaProcesso.sh &
#echo "Fim, mas não acabou. Pois vai acabar quando acabar."
