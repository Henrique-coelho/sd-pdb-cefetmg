#!/bin/bash

command=`tail -n1 $1`;

echo $command;

./geraArquivo.sh $command
