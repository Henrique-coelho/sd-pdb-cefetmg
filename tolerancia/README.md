# Modulo de Tolerância a falhas
## O que ele faz ?
Este módulo, repete uma tarefa que apresentou algum erro, **N** vezes. Caso a tarefa tenha executado sem nenhum erro, o estado na base de dados, será atualizado para CONCLUIDO, caso apresente erro, o estado será atualizado para PENDENTE.

## Como utilizar ?
Para utilizar este módulo, basta fazer a chamada deste módulo, e informar na mesma linha o outro script e argumentos utilizados.
```
  ./tolerancy_module.sh ./[nome-modulo2] [arg1] [arg2] ... [argN]
```
