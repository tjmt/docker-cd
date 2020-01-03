#!/bin/bash

echo "Iniciando entrypoint - TESTS"

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
