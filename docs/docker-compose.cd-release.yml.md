> Responsável por conter os argumentos para deploy da aplicação no kubernetes ou no Registry das bibliotecas (npm/nuget/maven)

Pré requisitos:
- image: Utilizar imagem gerada pelo `docker-compose.cd-publish.yml`
- environment: (Informar as variaveis necessárias para deploy da aplicação)
    - NUGET
        - DEPLOY_NUGET: `false`
        - NUGET_REGISTRY
        - NUGET_USER
        - NUGET_PASS
        - NUGET_LIFE_CICLE_VERSION
        - NUGET_PACKAGES_FOLDER: `/var/release/packages/nuget/`
    - NPM
        - DEPLOY_NPM: `false`
        - NPM_REGISTRY
        - NPM_USER
        - NPM_PASS
        - NPM_EMAIL
        - NPM_LIFE_CICLE_VERSION
        - NPM_PACKAGES_FOLDER: `/var/release/packages/npm/`
    - Maven
        - DEPLOY_MAVEN: `false`
        - MAVEN:_REGISTRY
        - MAVEN:_USER
        - MAVEN:_PASS
        - MAVEN:_PACKAGES_FOLDER: `/var/release/packages/maven/`
    - Kubernetes
        - DEPLOY_KUBERNETES: `false`
        - KUBERNETES_FOLDER: `/var/release/source/`


<details>
  <summary>Exemplo 1 (Nuget/Kubernetes)</summary>

```yml
version: '3.5'

services:
  sistema-api-tjmt-jus-br:
    image: ${DOCKER_REGISTRY}sistema-api.tjmt.jus.br:${BRANCH:-develop}.${VERSION:-local}-publish
    environment:
      DOCKER_REGISTRY: ${DOCKER_REGISTRY}
      ENVIRONMENT: ${ENVIRONMENT:-dev}
      NUGET_LIFE_CICLE_VERSION: ${NUGET_LIFE_CICLE_VERSION:-local}
      DEPLOY_NUGET: ${DEPLOY_NUGET:-true}
      DEPLOY_KUBERNETES: ${DEPLOY_KUBERNETES:-true}
```      
</details>