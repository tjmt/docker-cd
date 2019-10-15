#!/bin/bash

echo "Iniciando entrypoint"

if [[ ${RUN_TEST} = "true" ]]; then
    echo "-------------------------------------------------------"
    echo "npm test"
    npm test -- --watch=false --browsers=ChromeHeadlessNoSandbox --code-coverage || true;
    echo "-------------------------------------------------------"

    echo "-------------------------------------------------------"
    echo "npm run e2e"
    npm run e2e || true;
    echo "-------------------------------------------------------"

    #https://docs.sonarqube.org/7.7/analysis/coverage/
    #https://github.com/tornaia/karma-sonarqube-unit-reporter
    #https://docs.sonarqube.org/latest/analysis/generic-test/
    if [[ ${RUN_SONARQUBE} = "true" ]]; then        
        echo "-------------------------------------------------------"
        echo "Sonar properties"
        echo "SONARQUBE_PROJECT $SONARQUBE_PROJECT"
        echo "SONARQUBE_PROJECT_VERSION $SONARQUBE_PROJECT_VERSION"
        echo "SONARQUBE_URL $SONARQUBE_URL"        
        echo "-------------------------------------------------------"

        sonar-scanner -Dsonar.projectKey="$SONARQUBE_PROJECT" -Dsonar.projectVersion="$SONARQUBE_PROJECT_VERSION" -Dsonar.projectName="$SONARQUBE_PROJECT" -Dsonar.host.url="$SONARQUBE_URL" -Dsonar.login=$SONARQUBE_LOGIN -Dsonar.password=$SONARQUBE_PASSWORD || true;
    fi
fi

if [[ ${RUN_PROJECT} = "true" ]]; then
    echo "--- Variaveis de ambiente ---"
    printenv
    echo "-----------------------------"

    configPath="/app/src/assets/config"
    envsubst < "${configPath}/config-docker.json" > "${configPath}/config.json"

    echo "--- Configurações das variáveis de ambiente utilizadas ---"
    cat ${configPath}/config.json
    echo "----------------------------------------------------------"

    npm run start || true;
fi