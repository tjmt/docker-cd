#!/bin/sh

echo "--- Variaveis de ambiente ---"
printenv
echo "-----------------------------"

envsubst < "/usr/share/nginx/html/assets/config/config-docker.json" > "/usr/share/nginx/html/assets/config/config.json"

echo "--- Configurações das variáveis de ambiente utilizadas ---"
cat /usr/share/nginx/html/assets/config/config.json
echo "----------------------------------------------------------"

nginx -g "daemon off;"