#!/usr/bin/env python3
# Convertido pelo ChatGPT de Shell script para Python

import csv
import random
import string
import requests

def gerar_senha(comprimento):
    caracteres = string.ascii_letters + string.digits
    senha = ''.join(random.choice(caracteres) for _ in range(comprimento))
    return senha

def simular(*args):
    for arg in args:
        if ' ' in arg:
            print(f'"{arg}"', end=' ')
        else:
            print(arg, end=' ')
    print()

URL_CSV = "https://raw.githubusercontent.com/jurandysoares/eleitores-ifrn-2019/master/csv/alunos.csv"
CSV_ALUNOS = "alunos.csv"

# Download CSV file
response = requests.get(URL_CSV)
with open(CSV_ALUNOS, mode='w', encoding='utf-8') as f:
    f.write(response.text)

for sbr_nome in ['martins', 'soares']:
    CSV_SOBRENOME = f"{sbr_nome}.csv"
    with open(CSV_ALUNOS, mode='r', encoding='utf-8') as arq_csv:
        leitor = csv.reader(arq_csv)
        dados = [linha for linha in leitor if sbr_nome in linha[1].lower()]
        dados = dados[-50:]  # Obtém as últimas 50 linhas

    print(dados)
    if len(dados) == 50:
        simular('samba-tool', 'group', 'add', sbr_nome)

        with open(f"{sbr_nome}-criados.csv", mode='w', encoding='utf-8', newline='') as arq_csv:
            escritor = csv.writer(arq_csv)
            escritor.writerow(['matricula', 'senha', 'nome_completo'])

            for dados_conta in dados:
                matricula, nome_completo = dados_conta[:2]
                nome_conta = f'ra{matricula}'
                nome_formatado = nome_completo.title()
                senha = gerar_senha(25)
                simular('samba-tool', 'user', 'create', '--use-username-as-cn',
                        '--must-change-at-next-login', '--description', nome_formatado,
                        nome_conta, senha)
                simular('samba-tool', 'group', 'addmember', sbr_nome, matricula)
                escritor.writerow([nome_conta, senha, nome_formatado])
    else:
        print(f"Número insuficiente de usuários foram encontrados com sobrenome '{sbr_nome}'.")
