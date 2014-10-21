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
#  Observacoes: Observacoes relevantes para o processamento
# Dependencias: Relacoes de dependencia para execucao, como arquivos
#                 auxiliares esperados, estrutura de diretorios, etc.
#               NECESSARIAMENTE entre o servidor de trigramas e esta maquina
#                 deve haver uma CHAVE PUBLICA DE AUTENTICACAO, de forma que
#                 seja dispensada a interacao com operador para os processos
#                 de transferencia de arquivos.
# ------------------------------------------------------------------------- #
#   DATA    Responsaveis      Comentarios
# 20090721  FLBrito           Edicao original
# 20100218  FBatalha/FJLopes  Inclusao de 'DOES NOT EXIST'
# 20100622  FJLopes           Inclusao de 'toomany arguments' e outros
#---------------------------------------------------------------------------#

TPR="start"
. log

# Verifica a passagem do parametro
if [ "$#" -ne 1 ]
then
   TPR="fatal"
   MSG="use: confout.sh <file_out>"
   . log
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

