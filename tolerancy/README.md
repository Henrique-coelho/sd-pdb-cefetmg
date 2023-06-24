# Modulo de Tolerância a falhas
## O que ele faz ?
Este módulo, repete uma tarefa que apresentou algum erro, **N** vezes. Caso a tarefa tenha executado sem nenhum erro, o estado na base de dados, será atualizado para CONCLUIDO, caso apresente erro, o estado será atualizado para PENDENTE.

O diagrama baixo representa o funcionamento do nosso módulo:
![daigrama tolerancia falhas](https://github.com/Henrique-coelho/sd-pdb-cefetmg/assets/73560471/efa24dba-0194-457f-95c0-81f9ac1300dd)

## Como utilizar ?
Para utilizar este módulo, basta fazer a chamada deste módulo, e informar na mesma linha o outro script e argumentos utilizados.
```
  ./tolerancyModule.sh [id-interacao] [nome-modulo2] [arg1] [arg2] ... [argN]
```

