# Objetivo

> Responsável por conter os argumentos e serviços necessários para executar os testes de integração que necessitam de um ambiente completo para execução dos testes. (Exemplo: banco de dados, API)

Pré requisitos:
- tag: `${BRANCH}.${VERSION}-tests`
- target: `tests`
- volume
  - Caminho padrão (`/app/TestResults`)

<details>
  <summary>Exemplo 1 (Frontend) - Dependência de uma API</summary>

```yml
version: '3.6'

services:
  app-front-end:
    image: ${DOCKER_REGISTRY}sistema.cnj.jus.br:${BRANCH}.${VERSION:-local}-tests
    container_name: ci-tests-artifacts
    build:
      target: tests
    environment:
      RUN_SONARQUBE: ${RUN_SONARQUBE:-true}
      SONARQUBE_URL: ${SONARQUBE_URL:-http://172.17.0.1:9000}
      SONARQUBE_LOGIN: ${SONARQUBE_LOGIN}
      SONARQUBE_PROJECT: sistema.cnj.jus.br
      SONARQUBE_PROJECT_VERSION: ${VERSION:-local}
```
</details>

<details>
  <summary>Exemplo 2 (Backend) - Dependencia de um banco</summary>

```yml
version: '3.6'

services:
  app-back-end:
    image: ${DOCKER_REGISTRY}sistema-api.cnj.jus.br:${BRANCH}.${VERSION:-local}-tests
    container_name: ci-tests-artifacts
    build:
      target: tests
    entrypoint: ["/entrypoint/wait-for-it.sh", "sistema-mssql:1433", "--", "/entrypoint/entrypoint.sh"]
    environment:
      SGDB_API: 'SQLSERVER'
      CONNECTION_STRING_API: 'Server=sistema-mssql,1433;Database=Banco;User Id=sa;Password=P@ssw0rd;'
      ASPNETCORE_ENVIRONMENT: 'Development'
      HOST_API: ${HOST_API:-http://localhost}
      RUN_SONARQUBE: ${RUN_SONARQUBE:-true}
      SONARQUBE_URL: ${SONARQUBE_URL:-http://172.17.0.1:9000}
      SONARQUBE_LOGIN: ${SONARQUBE_LOGIN}
      SONARQUBE_PROJECT: sistema-api.cnj.jus.br
      SONARQUBE_PROJECT_VERSION: ${VERSION:-local}

  sistema-mssql:
    image: ${DOCKER_REGISTRY}sistema-mssql-server.cnj.jus.br:20190827.1
    ports:
      - 1433:1433
    environment:
      ACCEPT_EULA: 'Y'
      SA_PASSWORD: P@ssw0rd
      DATABASE: Banco
```
</details>
