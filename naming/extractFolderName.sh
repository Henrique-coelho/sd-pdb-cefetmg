#!/bin/bash

# Verifica se a quantidade correta de parâmetros foi informada
if [ $# -ne 4 ]; then
    echo "Usage: $0 <variable1> <variable2> <variable3> <variable4>"
    exit 1
fi

# Arquivo com interações
file_path="interacoes.csv"

# Arquivo pode não existir
if [ -f "$file_path" ]; then
    # Lê o arquivo e encontra a linha correspondente
    while IFS=: read -r var1 var2 var3 var4 rest; do
        # Todas as variáveis batem com os parâmetros
        if [[ "$var1" == *"$1"* && "$var2" == *"$2"* && "$var3" == *"$3"* && "$var4" == *"$4"* ]]; then
            # Extrai a informação após o quarto :
            interation_name=${rest#*:*:*:*:}

            # Imprime o nome da interação
            echo "$interation_name"
            exit 0
        fi
    done < "$file_path"

    echo "No matching interaction found for the given variables."
else
    echo "The file $file_path does not exist."
fi
