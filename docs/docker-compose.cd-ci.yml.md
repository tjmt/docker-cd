> Responsável por conter os argumentos e serviços necessários para executar os testes de integração que necessitam de um ambiente completo para execução dos testes. (Exemplo: banco de dados, API)

Pré requisitos:
- tag: `${BRANCH}.${VERSION}-ci`
- target: `ci`
- volume
    - Criar um volume mapeando para a pasta com os resultados dos testes
        - Pasta padrão (`/app/TestResults`)
        - Nomear usando variavel de ambiente: `${DOCKERCOMPOSE_CI_VOLUME_NAME}`



<details>
  <summary>Exemplo 1 (Frontend) - Dependencia de uma API</summary>

```yml
version: '3.5'

services:
  sistema-tjmt-jus-br:
    image: ${DOCKER_REGISTRY}sistema.tjmt.jus.br:${BRANCH:-develop}.${VERSION:-local}-ci
    container_name: sistema-${BRANCH:-develop}-ci.tjmt.jus.br
    build:
      target: ci
    environment:
      RUN_TEST: ${RUN_TEST:-true}
      RUN_PROJECT: ${RUN_PROJECT:-false}
      RUN_SONARQUBE: ${RUN_SONARQUBE:-true}
      SONARQUBE_URL: ${SONARQUBE_URL:-http://172.17.0.1:9000}
      SONARQUBE_LOGIN: ${SONARQUBE_LOGIN}
      SONARQUBE_PROJECT: sistema.tjmt.jus.br
      SONARQUBE_PROJECT_VERSION: ${VERSION:-local}
    volumes:
      - test-result:/app/TestResults

networks:
  default:
    name: ns-sistema-ci

volumes:
  test-result:
    name: ${DOCKERCOMPOSE_CI_VOLUME_NAME:-sistema-test-results}

```
</details>

<details>
  <summary>Exemplo 2 (Backend) - Dependencia de um banco</summary>

```yml
#docker-compose -f .\docker-compose.build.yml build
version: '3.5'

services:
  sistema-api-tjmt-jus-br:
    image: ${DOCKER_REGISTRY}sistema-api.tjmt.jus.br:${BRANCH:-develop}.${VERSION:-local}-ci
    container_name: sistema-api-${BRANCH:-develop}-ci.tjmt.jus.br
    build:
      target: ci
    entrypoint: ["/entrypoint/wait-for-it.sh", "sistema-mssql:1433", "--", "/entrypoint/entrypoint.sh"]      
    environment:
      RUN_TEST: ${RUN_TEST:-true}          
      SGDB_API: 'SQLSERVER'
      CONNECTION_STRING_API: 'Server=sistema-mssql,1433;Database=Banco;User Id=sa;Password=P@ssw0rd;'
      ASPNETCORE_ENVIRONMENT: 'Development'
      HOST_API: ${HOST_API:-http://localhost}
      RUN_TEST: ${RUN_TEST:-true}      
      RUN_SONARQUBE: ${RUN_SONARQUBE:-true}
      SONARQUBE_URL: ${SONARQUBE_URL:-http://172.17.0.1:9000}
      SONARQUBE_LOGIN: ${SONARQUBE_LOGIN}
      SONARQUBE_PROJECT: sistema.tjmt.jus.br
      SONARQUBE_PROJECT_VERSION: ${VERSION:-local}
    volumes:
      - test-result:/TestResults      

  sistema-mssql:
    image: nexusdocker.tjmt.jus.br/teste/sistema-mssql-server.tjmt.jus.br:20190827.1
    ports:
      - 1433:1433
    environment:
      ACCEPT_EULA: 'Y'
      SA_PASSWORD: P@ssw0rd
      DATABASE: Banco

networks:
  default:
    name: ns-sistema-api-ci

volumes:
  test-result:
    name: ${DOCKERCOMPOSE_CI_VOLUME_NAME:-sistema-api-test-results}
```
</details>