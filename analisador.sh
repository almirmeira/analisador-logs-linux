#!/bin/bash
# analisador.sh - Analisador simples de logs de autenticação Linux

LOG_DIR="/var/log"
AUTH_LOG="$LOG_DIR/auth.log"
SECURE_LOG="$LOG_DIR/secure"
OUTPUT_TXT="relatorio_autenticacao.txt"
OUTPUT_JSON="relatorio_autenticacao.json"
DATA_FILTRO=""
IP_FILTRO=""

# Verifica argumentos
while getopts "d:i:" opt; do
  case ${opt} in
    d ) DATA_FILTRO=$OPTARG ;;
    i ) IP_FILTRO=$OPTARG ;;
    \? ) echo "Uso: cmd [-d AAAA-MM-DD] [-i IP]"; exit 1 ;;
  esac
done

# Detectar qual log está presente
if [[ -f "$AUTH_LOG" ]]; then
    LOGFILE=$AUTH_LOG
elif [[ -f "$SECURE_LOG" ]]; then
    LOGFILE=$SECURE_LOG
else
    echo "Arquivo de log não encontrado."; exit 1
fi

# Filtro de data/IP se presente
FILTRO_CMD="cat $LOGFILE"
if [[ $DATA_FILTRO != "" ]]; then
    FILTRO_CMD="$FILTRO_CMD | grep \"$DATA_FILTRO\""
fi
if [[ $IP_FILTRO != "" ]]; then
    FILTRO_CMD="$FILTRO_CMD | grep \"$IP_FILTRO\""
fi

LOGS_FILTRADOS=$(eval $FILTRO_CMD)

# Gerar saída TXT
echo "Relatório de autenticação - $(date)" > $OUTPUT_TXT
echo "[DATA: $DATA_FILTRO] [IP: $IP_FILTRO]" >> $OUTPUT_TXT

echo -e "\n[1] Logins mal sucedidos:" >> $OUTPUT_TXT
echo "$LOGS_FILTRADOS" | grep "Failed password" | awk '{print $1, $2, $3, $11, $13}' | sort | uniq -c >> $OUTPUT_TXT

echo -e "\n[2] Logins bem sucedidos:" >> $OUTPUT_TXT
echo "$LOGS_FILTRADOS" | grep "Accepted password" | awk '{print $1, $2, $3, $9, $11}' | sort | uniq -c >> $OUTPUT_TXT

# Exportar para JSON simples
echo "{" > $OUTPUT_JSON
echo "  \"data_filtro\": \"$DATA_FILTRO\"," >> $OUTPUT_JSON
echo "  \"ip_filtro\": \"$IP_FILTRO\"," >> $OUTPUT_JSON
echo "  \"logins_falhos\": [" >> $OUTPUT_JSON
echo "$LOGS_FILTRADOS" | grep "Failed password" | awk -F' ' '{printf "    {\"data\":\"%s %s %s\", \"usuario\":\"%s\", \"ip\":\"%s\"},\n", $1,$2,$3,$11,$13}' | sed '$ s/,$//' >> $OUTPUT_JSON
echo "  ]," >> $OUTPUT_JSON
echo "  \"logins_sucesso\": [" >> $OUTPUT_JSON
echo "$LOGS_FILTRADOS" | grep "Accepted password" | awk -F' ' '{printf "    {\"data\":\"%s %s %s\", \"usuario\":\"%s\", \"ip\":\"%s\"},\n", $1,$2,$3,$9,$11}' | sed '$ s/,$//' >> $OUTPUT_JSON
echo "  ]" >> $OUTPUT_JSON
echo "}" >> $OUTPUT_JSON

echo "Relatórios salvos em: $OUTPUT_TXT e $OUTPUT_JSON"

# Opcional: Enviar por e-mail ou API
if [[ -n "$EMAIL_DEST" ]]; then
    mail -s "Relatório de autenticação Linux" "$EMAIL_DEST" < $OUTPUT_TXT
fi
if [[ -n "$API_URL" ]]; then
    curl -X POST -H "Content-Type: application/json" -d @"$OUTPUT_JSON" "$API_URL"
fi
