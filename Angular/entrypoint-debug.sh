#!/bin/bash

echo "Iniciando entrypoint - DEBUG"

echo "--- Variáveis de ambiente ---"
printenv | sort
echo "-----------------------------"

configPath="/app/src/assets/config"
envsubst < "${configPath}/config-docker.json" > "${configPath}/config.json"

echo "--- Configurações das variáveis de ambiente utilizadas ---"
cat ${configPath}/config.json
echo "----------------------------------------------------------"

npm run start || true;