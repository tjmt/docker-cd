# Objetivo

> Responsável pela execução do processo de Continuous Integration (CI) para o processo de automação. Ele contém a pipeline necessária para utilizar todos os artefatos contidos nesse repositório.

Pré requisitos:
- Configurar os valores das variáveis de ambiente contidas nele:

  - Variáveis de configuração geral
    - **BRANCH** - nome da branch
    - **VERSION** - código de versão
    - **DOCKER_REGISTRY** - endereço do registry privado. Caso não tenha, deixe o valor em branco para ele utilizar o registry público oficial
    - **DOCKER_LOGIN** - login do registry privado
    - **DOCKER_PASSWORD** - senha do registry privado
    - **DOCKER_SERVICES** - indica quais serão os serviços do Docker-Compose a serem utilizados

  - Variáveis específicas utilizadas no build
    - **ARTIFACT_STAGING_DIRECTORY** - path utilizado para copiar os artefatos gerados durante processo de teste e build
    - **DOCKER_PUSH** - flag para indicar se realizará push das imagens
    - **RUN_LOCAL** - flag para indicar se irá rodar a aplicação local
    - **TARGET** - indica qual será o estágio de Docker a ser executado

  - Variáveis utilizadas nos testes
    - **RUN_TEST** - flag para indicar se irá rodar os testes
    - **RUN_SONARQUBE** - flag para indicar se irá rodar o sonarqube
    - **SONARQUBE_URL** - endereço do sonarqube, caso tenha
    - **SONARQUBE_LOGIN** - login (token) do sonarqube, caso tenha

  - .NET - Variáveis específicas utilizadas nos testes
    - **DOTNET_TEST_FILTER** - filtro de testes utilizado no comando `dotnet test --filter`

  - Angular - Variáveis específicas utilizadas nos testes
    - **NG_E2E_SPECS** - filtro de testes utilizado no comando `ng e2e --specs`
    - **NG_TEST_SPECS** - filtro de testes utilizado no comando `ng test --include`

Exemplo:
- [ci.sh](../ci.sh)
