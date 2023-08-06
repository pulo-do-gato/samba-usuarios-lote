#!/bin/bash

# Função criada com auxílio do ChatGPT
# https://chat.openai.com/share/7284bcdf-ac49-41dd-af9a-aae704eff915
gerar_senha() {
    local comprimento=$1
    local caracteres="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local senha=""

    # Verifica se o argumento é válido e não é vazio
    if [[ -z "$comprimento" || ! "$comprimento" =~ ^[0-9]+$ ]]; then
        echo "Por favor, forneça um número inteiro positivo como argumento para o comprimento da senha."
        return 1
    fi

    # Gera a senha
    for (( i = 0; i < comprimento; i++ )); do
        local indice=$((RANDOM % ${#caracteres}))
        senha+=${caracteres:$indice:1}
    done

    echo "$senha"
}

# Simular execução de comando
simular() {
    for arg in "$@"; do
        if [[ $arg == *" "* ]]; then
            echo -n '"'${arg}'"'  " "
        else
            echo -n "${arg}" " "
        fi
    done
    echo
}

URL_CSV="https://raw.githubusercontent.com/jurandysoares/eleitores-ifrn-2019/master/csv/alunos.csv"
CSV_ALUNOS="alunos.csv"

# Baixa arquivo CSV
curl -O "${URL_CSV}"

for sbr_nome in martins soares; do

    # Filtra os últimos 50 alunos com o sobrenome
    CSV_SOBRENOME="${sbr_nome}.csv"
    grep -i "${sbr_nome}" "${CSV_ALUNOS}" | tail -50 | cut -d, -f1,2 | sed 's/^/ra/' > "${CSV_SOBRENOME}"
    qt_linhas_csv=$(cat "${CSV_SOBRENOME}" | wc -l)

    if [[ $qt_linhas_csv -eq 50 ]]; then
        simular samba-tool group add "${sbr_nome}"

        # Limpa conteúdo do arquivo
        echo > "${sbr_nome}-criados.csv"
        while IFS="," read matricula nome_completo; do
            senha=$(gerar_senha 25)
            simular samba-tool user create --use-username-as-cn --must-change-at-next-login --description "${nome_completo}" "${matricula}" "${senha}"
            simular samba-tool group addmember "${sbr_nome}" "${matricula}"
            echo "${matricula},${senha},${nome_completo}" >> "${sbr_nome}-criados.csv"
        done < "${CSV_SOBRENOME}"
    else
        echo "Número insuficiente de usuários foram encontrados com sobrenome ""${sbr_nome}""."
    fi
done

