#!/bin/bash

echo "Iniciando entrypoint - TESTS"

mkdir -p /TestResults

if [[ "$TARGET" == 'tests' || "$RUN_TEST" == 'true' ]]; then

  echo "-------------------------------------------------------"
  echo "npm test"
  NG_TEST = 'npm test -- --watch=false --browsers=ChromeHeadlessNoSandbox --code-coverage --include $NG_TEST_SPECS || true'
  $NG_TEST || true;
  echo "-------------------------------------------------------"

  echo "-------------------------------------------------------"
  echo "npm run e2e"
  NG_E2E="npm run e2e -- --specs $NG_E2E_SPECS";
  $NG_E2E || true;
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

  cp -avr ./TestResults /TestResults

fi

if [[ "$TARGET" == 'tests' && "$RUN_LOCAL" == 'true' ]]; then
	. entrypoint-debug.sh
fi
