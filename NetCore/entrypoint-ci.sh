#!/bin/bash

# Necessário instalar esses pacotes nos projetos de teste
#https://gunnarpeipman.com/aspnet/code-coverage/
# coverlet.msbuild
# Microsoft.CodeCoverage
# XunitXml.TestLogger

echo "Iniciando entrypoint"

if [[ ${RUN_TEST} = "true" ]]; then

    #Análise de T-SQL code
    #https://marketplace.visualstudio.com/items?itemName=Ubitsoft.sql-enlight-vsts-extension
    if [[ ${RUN_SONARQUBE} != "" ]]; then
        
        echo "-------------------------------------------------------"
        echo "Sonar properties"
        echo "SONARQUBE_PROJECT: $SONARQUBE_PROJECT"
        echo "SONARQUBE_PROJECT_VERSION: $SONARQUBE_PROJECT_VERSION"
        echo "SONARQUBE_URL: $SONARQUBE_URL"        
        echo "-------------------------------------------------------"

        #dotnet sonarscanner não aceita SONARQUBE_PASSWORD em branco
        #/d:sonar.password=$SONARQUBE_PASSWORD
        dotnet sonarscanner begin /k:"$SONARQUBE_PROJECT" /v:"$SONARQUBE_PROJECT_VERSION" /d:sonar.login=$SONARQUBE_LOGIN /d:sonar.host.url=${SONARQUBE_URL} /d:sonar.cs.vstest.reportsPaths="${RESULT_PATH}*.trx" /d:sonar.cs.opencover.reportsPaths="${COVERAGE_PATH}**/coverage.opencover.xml" || true;
    fi

    #code coverage para testes de integraçao
    #https://github.com/OpenCover/opencover/issues/668
    #https://github.com/tonerdo/coverlet/issues/161 => multiple CoverletOutputFormat
    CoverletOutputFormat="cobertura,opencover"

    echo "-------------------------------------------------------"
    echo "dotnet properties"
    echo "SOLUTION_NAME: $SOLUTION_NAME"
    echo "RESULT_PATH: $RESULT_PATH"
    echo "COVERAGE_PATH: $COVERAGE_PATH"
    echo "COVERLET_OUTPUT_FORMAT: $CoverletOutputFormat"
    echo "COVERAGE_REPORT_PATH: $COVERAGE_REPORT_PATH"
    echo "-------------------------------------------------------"

    #necessário rodar o dotnet build entre o begin e end do sonarqube
    echo "Iniciando dotnet build $SOLUTION_NAME"
    dotnet build $SOLUTION_NAME -v m --no-restore

    echo "Iniciando dotnet test $SOLUTION_NAME"
    #https://github.com/tonerdo/coverlet/issues/37  => Coverage report is not generated if there are any failing tests
    dotnet test $SOLUTION_NAME --no-build --no-restore -v m --logger "trx;LogFileName=TestResults.trx" --results-directory $RESULT_PATH /p:CollectCoverage=true /p:CoverletOutput=$COVERAGE_PATH "/p:CoverletOutputFormat=\"${CoverletOutputFormat}\"" || true;


    #Para gerar covertura de código mesmo com teste falhando, usar coverlet
    #https://github.com/tonerdo/coverlet
    #https://www.nuget.org/packages/coverlet.console/
    
    #https://danielpalme.github.io/ReportGenerator/usage.html
    echo 'Iniciando reportgenerator'
    reportgenerator "-reports:$COVERAGE_PATH/coverage.cobertura.xml" "-targetdir:$COVERAGE_REPORT_PATH" -reporttypes:"HTMLInline" "-verbosity:Error" -verbosity:Error || true;

    if [[ ${RUN_SONARQUBE} != "" ]]; then
        dotnet sonarscanner end /d:sonar.login="${SONAR_LOGIN}" || true;    
    fi
fi