#!/bin/bash
# ------------------------------------------------------------------------- #
# confout.sh - Busca por palavras que possam identificar erro
# ------------------------------------------------------------------------- #
#      Entrada: arquivo de out
#        Saida: mostragem na tela
#     Corrente: 
#      Chamada: confout.sh <arquivo de out>
#      Exemplo: confout.sh proc.20090721.out
#  Comentarios: as palavras consideradas como erro sao as observadas nos processos
# ------------------------------------------------------------------------- #
#   DATA    Responsaveis      Comentarios
# 20090721  FLBrito           Edicao original
#---------------------------------------------------------------------------#


# Verifica a passagem do parametro
if [ "$#" -ne 1 ]
then
   echo
   echo "ERRO"
   echo "use: confout.sh <file_out>"
   exit 0
fi

ARQUIVO=$1

#------------------------------------------------------------------------#
# Busca de palavras especificas
#------------------------------------------------------------------------#
grep -i -n "fatal: " $1  > tmp
grep -i -n "\bERRO[S]\b" $1  >> tmp
grep -i -n "\bErro\b" $1  >> tmp
grep -i -n segmentation $1  >> tmp
grep -n "o such" $1 >> tmp
grep -i -n "\bdenied\b" $1 >> tmp
grep -i -n "Connection refused" $1 >> tmp

grep -n "does not exist" $1 >> tmp

grep -n "== ERRO ===" $1 >> tmp
grep -n "\-\- Arquivo nao encontrado" $1 >> tmp
grep -n "too many arguments" $1 >> tmp

case $(wc -c tmp) in
     0*) 
        echo "+-----------------------------------------------------------+"
        echo "| Processamento OK!!!                                       |" 
        echo "| Nao foram encontrados erros conhecidos no arquivo abaixo: |"
        echo "+-----------------------------------------------------------+"
        echo "Arquivo conferido: $ARQUIVO"
        echo
        echo
        rm tmp;;
      *)  
        echo "+-----------------------------------------------------------+"
        echo "| ATENCAO! - Erros conhecidos foram encontrados no arquivo:"
        echo "| Arquivo conferido: $ARQUIVO"
        echo "+-----------------------------------------------------------+"
        cat tmp
        echo "+-----------------------------------------------------------+"
        echo
        echo
        rm tmp;;
esac

