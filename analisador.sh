#!/bin/bash
# analisador.sh - Logins locais e via SSH no Ubuntu (auth.log)

LOG_DIR="/var/log"
AUTH_LOG="$LOG_DIR/auth.log"
OUTPUT_FILE="relatorio_autenticacao.txt"

echo "==========================================" > $OUTPUT_FILE
echo "RELATÓRIO DE AUTENTICAÇÃO - $(date)" >> $OUTPUT_FILE
echo "==========================================" >> $OUTPUT_FILE

if [[ ! -f "$AUTH_LOG" ]]; then
    echo "Arquivo $AUTH_LOG não encontrado."
    exit 1
fi

# SSH: Logins mal sucedidos
echo -e "\n[1] SSH - TENTATIVAS DE LOGIN INVÁLIDAS:" >> $OUTPUT_FILE
grep "Failed password" $AUTH_LOG | awk '{print $1, $2, $3, "Usuário:", $11, "IP:", $13}' | sort | uniq -c >> $OUTPUT_FILE

# SSH: Logins bem sucedidos
echo -e "\n[2] SSH - LOGINS BEM SUCEDIDOS:" >> $OUTPUT_FILE
grep "Accepted password" $AUTH_LOG | awk '{print $1, $2, $3, "Usuário:", $9, "IP:", $11}' | sort | uniq -c >> $OUTPUT_FILE

# Sessões locais abertas (gdm, tty, su, sudo)
echo -e "\n[3] SESSÕES ABERTAS (local + remoto):" >> $OUTPUT_FILE
grep "session opened for user" $AUTH_LOG | awk '{print $1, $2, $3, "Usuário:", $11, "Por:", $13}' | sort >> $OUTPUT_FILE

# Sessões locais encerradas
echo -e "\n[4] SESSÕES ENCERRADAS:" >> $OUTPUT_FILE
grep "session closed for user" $AUTH_LOG | awk '{print $1, $2, $3, "Usuário:", $11}' | sort >> $OUTPUT_FILE

# Uso do sudo
echo -e "\n[5] USO DO SUDO:" >> $OUTPUT_FILE
grep "sudo" $AUTH_LOG | grep "COMMAND=" | awk '{print $1, $2, $3, "Usuário:", $9, "Comando:", $15}' | sort >> $OUTPUT_FILE

# Uso do su
echo -e "\n[6] USO DO SU (troca de usuário):" >> $OUTPUT_FILE
grep "su:" $AUTH_LOG | grep "session opened" | awk '{print $1, $2, $3, "SU iniciado por:", $11}' | sort >> $OUTPUT_FILE

# Falhas de autenticação (PAM)
echo -e "\n[7] FALHAS DE AUTENTICAÇÃO (PAM):" >> $OUTPUT_FILE
grep "authentication failure" $AUTH_LOG | awk '{print $1, $2, $3, $NF}' | sort >> $OUTPUT_FILE

echo -e "\n[✓] Relatório salvo em $OUTPUT_FILE"

