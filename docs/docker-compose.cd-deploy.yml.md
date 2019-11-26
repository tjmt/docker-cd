# Objetivo

* Responsável pelo deploy dos artefatos.
  * Aplicação no kubernetes e/ou no Registry das bibliotecas (npm/nuget/maven)

Pré requisitos:
- image: 
  - Utilizar imagem gerada pelo `docker-compose.cd-publish.yml`
- environment: (Informar as variaveis necessárias para deploy da aplicação)
  - NUGET
    - DEPLOY_NUGET (*default:* `false`)
    - NUGET_REGISTRY
    - NUGET_USER
    - NUGET_PASS
    - NUGET_LIFE_CICLE_VERSION
    - NUGET_PACKAGES_FOLDER (*default:* `/var/release/packages/nuget/`)
  - NPM
    - DEPLOY_NPM (*default:* `false`)
    - NPM_REGISTRY
    - NPM_USER
    - NPM_PASS
    - NPM_EMAIL
    - NPM_LIFE_CICLE_VERSION
    - NPM_PACKAGES_FOLDER (*default:* `/var/release/packages/npm/`)
  - Maven
    - DEPLOY_MAVEN (*default:* `false`)
    - MAVEN:_REGISTRY
    - MAVEN:_USER
    - MAVEN:_PASS
    - MAVEN:_PACKAGES_FOLDER (*default:* `/var/release/packages/maven/`)
  - Kubernetes
    - KUBERNETES_FOLDER (*default:* `/var/release/source/`)
    - KUBECONFIG_PATH (*default:* `${KUBERNETES_FOLDER}kubeconfig`)
    - COMPOSE_PATH _Informar o arquivos docker-compose.yml caso queria usar o kompose para converter para yaml_
    - DEPLOY_KUBERNETES (*default:* `false`) _Realiza `kubectl apply` nos arquivos *.yaml presentes na pasta informado pela variavel `$(KUBERNETES_FOLDER)`_
    - DESTROY_KUBERNETES_ENVIRONMENT (*default:* `false`) _Realiza `kubectl delete` nos arquivos *.yaml presentes na pasta informado pela variavel `$(KUBERNETES_FOLDER)`_


Exemplo:
- [docker-compose.cd-deploy.yml](../docker-compose.cd-deploy.yml)
