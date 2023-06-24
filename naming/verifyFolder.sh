#!/bin/bash

MAX_FILES_IN_FOLDER=10000
# recebe o path do diretório como argumento
path=$1

# verifica a existência da pasta
if [ ! -d $path ]; then
  echo "$path";
  exit 0;
else
  value="$(find "$path" -maxdepth 1 -type f | wc -l)";
  
  # verifica se a quantidade de arquivos é menor que 1 milhão
  if [ $value -lt $MAX_FILES_IN_FOLDER ]; then
    echo "$path";
    exit 0;
  fi
fi

number=1
while true; do
  new_path="$path"_"$number"
  
  # verifica a existência da pasta
  if [ ! -d $new_path ]; then
    echo "$new_path";
    exit 0;
  else 
    new_value="$(find "$new_path" -maxdepth 1 -type f | wc -l)";

    # verifica se a quantidade de arquivos é menor que 1 milhão
    if [ $new_value -lt $MAX_FILES_IN_FOLDER ]; then
      echo "$new_value";
      break;
    fi
  fi
  number=$((number+1))
done
