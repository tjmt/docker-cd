# Objetivo

> Responsável pela execução do processo de Continuous Delivery (CD) para o processo de automação. Ele contém a pipeline necessária para utilizar todos os artefatos contidos nesse repositório.

Pré requisitos:
- Configurar os valores das variáveis de ambiente contidas nele:

  - Variáveis de configuração geral
    - **BRANCH** - nome da branch
    - **VERSION** - código de versão
    - **DOCKER_REGISTRY** - endereço do registry privado. Caso não tenha, deixe o valor em branco para ele utilizar o registry público oficial
    - **DOCKER_LOGIN** - login do registry privado
    - **DOCKER_PASSWORD** - senha do registry privado
    - **DOCKER_SERVICES** - indica quais serão os serviços do Docker-Compose a serem utilizados

  - Variável que define o ambiente em que será realizado o deploy
    - **DEPLOY_ENVIRONMENT** - ambiente em que será realizado o deploy

  - Kubernetes - Variáveis específicas utilizadas no publicador
    - **DEPLOY_KUBERNETES** - flag para indicar se irá publicar em um ambiente Kubernetes
    - **DESTROY_KUBERNETES_ENVIRONMENT** - flag para indicar se irá deletar o namespace da aplicação no Kubernetes
    - **COMPOSE_PATH** - path do do arquivo docker-compose (.yml) que será transformado pelo Kompose em um objeto Kubernetes (.yaml)
    - **KUBECONFIG_PATH** - path do kubeconfig a ser utilizado na publicação
    - **COMPOSE_RELEASE_PATH** - path dos artefatos gerados pelo *`ci.sh`*

  - NPM - Variáveis específicas utilizadas no publicador
    - **DEPLOY_NPM** - flag para indicar se irá publicar um pacote no npm
    - **NPM_LIFECYCLE_VERSION** - lifecycle do pacote npm (alpha, beta, rc, stable, etc)
    - **NPM_REGISTRY** - endereço do registry npm, caso tenha
    - **NPM_EMAIL** - email para login no registry
    - **NPM_USER** - usuário do registry
    - **NPM_PASS** - senha do registry
    - **NPM_PACKAGES_FOLDER** - path do pacote npm (.tgz)

  - Nuget - Variáveis específicas utilizadas no publicador
    - **DEPLOY_NUGET** - flag para indicar se irá publicar um pacote no nuget
    - **NUGET_LIFECYCLE_VERSION** - lifecycle do pacote nuget (alpha, beta, rc, stable, etc)
    - **NUGET_REGISTRY** - endereço do registry nuget, caso tenha
    - **NUGET_USER** - usuário do registry
    - **NUGET_PASS** - senha do registry
    - **NUGET_PACKAGES_FOLDER** - path do pacote nuget (.nupkg)

Exemplo:
- [cd.sh](../cd.sh)
