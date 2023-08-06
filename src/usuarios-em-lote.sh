#!/bin/bash

# TODO: Criar senha aleatória e salvá-la em arquivo CSV junto com nome de usuário
# TODO: Inserir usuários em um dos grupos associados a sobrenomes
#

URL_CSV="https://raw.githubusercontent.com/jurandysoares/eleitores-ifrn-2019/master/csv/alunos.csv"
CSV_ALUNOS="alunos.csv"

# Baixa arquivo CSV
curl -O "${CSV_ALUNOS}"

# Filtra os últimos 50 Martins
CSV_MARTINS="martins.csv"
grep -i martins "${CSV_ALUNOS}" | tail -50 | cut -d, -f1,2 | sed 's/^/ra/' > "${CSV_MARTINS}"

# Filtra os últimos 50 Soares
CSV_SOARES="soares.csv"
grep -i soares "${CSV_ALUNOS}" | tail -50 | cut -d, -f1,2 | sed 's/^/ra/' > "${CSV_SOARES}"

# Limpa conteúdo do arquivo
echo > "martins-criados.csv"

while IFS="," read matricula nome_completo; do
    senha="$(apg -n 1)"
    echo samba-tool user create --use-username-as-cn --must-change-at-next-login --description "${nome_completo}" "${matricula}" "${senha}"
    echo 
    echo "${matricula},${senha},${nome_completo}" >> "martins-criados.csv"
done < "${CSV_MARTINS}"

# Limpa conteúdo do arquivo
echo > "soares-criados.csv"
while IFS="," read matricula nome_completo; do
    senha="$(apg -n 1)"
    echo samba-tool user create --use-username-as-cn --description --must-change-at-next-login "${nome_completo}" "${matricula}" "${senha}"

    echo "${matricula},${senha},${nome_completo}" >> "soares-criados.csv"
done < "${CSV_SOARES}"
