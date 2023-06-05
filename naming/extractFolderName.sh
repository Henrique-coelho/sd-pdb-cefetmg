#!/bin/bash

# Verifica se a quantidade correta de parâmetros foi informada
if [ $# -ne 4 ]; then
    echo "Usage: $0 <variable1> <variable2> <variable3> <variable4>"
    exit 1
fi

# Arquivo com interações
file_path="../interacoes.csv"

# Arquivo pode não existir
if [ -f "$file_path" ]; then
    # Lê o arquivo e encontra a linha correspondente
    while IFS=: read -r var1 var2 var3 var4; do
        # Todas as variáveis batem com os parâmetros
        if [[ "$var1" == "$1 $2" || "$var2" == "$3 $4" ]]; then
            # Extrai a informação após o quarto :
            interation_name=$var4

            # Imprime o nome da interação
            echo "$interation_name"
            exit 0
        fi
    done < "$file_path"

    echo "Erro - Tipo de ligação não identificado."
else
    echo "Erro - Não foi possível localizar $file_path."
fi
