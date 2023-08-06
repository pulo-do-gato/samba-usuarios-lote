#!/bin/bash


#
#
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

echo "Exibição de matrícula e nome dos Martins"
while IFS="," read matricula nome; do
    echo "${matricula} -> ${nome_min}"
    echo samba-tool user create --use-username-as-cn --description "${nome}" "${matricula}"
done < "${CSV_MARTINS}"

echo "Exibição de matrícula e nome dos Soares"
while IFS="," read matricula nome; do
    echo "${matricula} -> ${nome_min}"
    echo samba-tool user create --use-username-as-cn --description "${nome}" "${matricula}"
done < "${CSV_SOARES}"
