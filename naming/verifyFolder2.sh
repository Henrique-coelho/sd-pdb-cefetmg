#!/bin/bash

MAX_FILES_IN_FOLDER=1000000
# recebe o path do diretório como argumento
path=$1

# verifica se a quantity de arquivos é menor que 1 milhão
if [ ! test -d $path ]; then
  echo $path
  else
    value="$(find "$path" -maxdepth 1 -type f | wc -l)" -lt $MAX_FILES_IN_FOLDER

    if [[ value -lt $MAX_FILES_IN_FOLDER ]]
      echo $path
    fi
else
  number=1
  while true; do
    new_path="$path"_"$number"
    if [ ! test -d $new_path ]; then
      echo "$new_path"
      break

      else 
        new_value="$(find "$new_path" -maxdepth 1 -type f | wc -l)" -lt $MAX_FILES_IN_FOLDER
        if [[ value -lt $MAX_FILES_IN_FOLDER ]]
          echo $path
          break
        fi
    fi
    number=$((number+1))
  done
fi


