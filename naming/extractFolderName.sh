#!/bin/bash

# Verifica se a quantidade correta de parâmetros foi informada
if [ $# -ne 4 ]; then
    echo "Usage: $0 <variable1> <variable2> <variable3> <variable4>"
    exit 1
fi

# Arquivo com interações
file_path="../interacoes.csv"

interation_name="Erro_Tipo_de_ligacao_nao_identificada";

# Arquivo pode não existir
if [ -f "$file_path" ]; then
    # Lê o arquivo e encontra a linha correspondente
    while IFS=: read -r var1 var2 var3 var4; do
        # Todas as variáveis batem com os parâmetros
        if [[ "$var1" == "$1 $2" || "$var2" == "$3 $4" ]]; then
            # Extrai a informação após o quarto :
            interation_name="$1-$2_$3-$4";

            # Imprime o nome da interação
            break;
        fi
    done < "$file_path"

    echo "$interation_name";
else
    echo "Erro - Nao foi possivel localizar $file_path."
fi
