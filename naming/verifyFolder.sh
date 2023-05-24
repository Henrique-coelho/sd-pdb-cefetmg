#!/bin/bash

# recebe o path do diretório como argumento
path=$1

# obtém a quantity de arquivos no diretório
quantity=$(find "$path" -maxdepth 1 -type f | wc -l)

# verifica se a quantity de arquivos é menor que 1 milhão
if [ "$quantity" -lt 1000000 ]; then
  echo "file_name"
else
  number=1
  while true; do
    new_name="file_name_$number"
    if [ ! -e "$path/$new_name" ] && [ "$(find "$path/$new_name" -maxdepth 1 -type f | wc -l)" -lt 1000000 ]; then
      echo "$new_name"
      break
    fi
    number=$((number+1))
  done
fi
