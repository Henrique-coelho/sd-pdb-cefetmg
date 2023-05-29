#!/bin/bash

script=$*

# data e horario do sistema 
data=`date +'%Y-%m-%d|%H:%M'`

./insertfault_tolerancy.sh 1 INICIADO $data 111 $1 

# executa tarefa e exporta resultado
$script > statusTask.txt

lineErro=`cat statusTask.txt | grep Erro | wc -l`

# data e horario apos o fim do processamento
data=`date +'%Y-%m-%d|%H:%M'`

if [ $lineErro -gt 0 ]; then
./updateTask.sh 1 PENDENTE $data 111 $1
# aqui deve ser alguma estrutura para repetir a tarefa n vezes
else
./updateTask.sh 1 CONCLUIDO $data 111 $1
fi
