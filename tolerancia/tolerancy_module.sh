#!/bin/bash

script=$*

# data e horario do sistema 
data=`date +'%Y-%m-%d|%H:%M'`;

# extrai id do dispositivo
system_id=$(hostname -I);

# extrai um nome para o script
nome_script=`echo $@ | sed 's/ /_/g'`;
nome_saida=$nome_script"_out.txt";
nome_status=$nome_script"_status.txt";

executa_script(){
	# executa tarefa e exporta resultado
	$script > $nome_saida 2> $nome_status

	# soma erros, da saida de erro e saida padrao
	erros=`cat $nome_status | wc -l`;
	erros_saida_padrao=`cat $nome_saida | grep -e Erro -e Usage | wc -l`;
	qtd_erros=`echo "$erros + $erros_saida_padrao" | bc`;

	# data e horario apos o fim do processamento
	data=`date +'%Y-%m-%d|%H:%M'`
}

# insere tarefa na base de dados
./insertTask.sh 1 INICIADO $data $system_id $nome_script 

# primeira execucao do script
executa_script

if [ $qtd_erros -gt 0 ]; then
./updateTask.sh 1 PENDENTE $data $system_id $nome_script

	CONTADOR=0;

	while [ $CONTADOR -lt 3 ]; do
		executa_script

		if [ $qtd_erros -eq 0 ]; then
			./updateTask.sh 1 CONCLUIDO $data $system_id $nome_script
			break
		if

		./updateTask.sh 1 PENDENTE $data $system_id $nome_script

		let CONTADOR=CONTADOR+1; 
	done

else

./updateTask.sh 1 CONCLUIDO $data $system_id $nome_script

fi

#remove arquivos de saida criados
rm $nomeSaida
rm $nomeStatus
