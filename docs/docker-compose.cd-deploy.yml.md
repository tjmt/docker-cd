# Objetivo

* Responsável pelo deploy dos artefatos gerados no processo de build.
  * Permite a publicação no Kubernetes ou nos registries para pacotes npm, Nuget ou Maven.

## Método convencional

Neste fluxo, ele utiliza a imagem do `tjmt/publicador`, vinculando o caminho dos arquivos gerados no build para o container do publicador.

Pré requisitos:
- image: 
  - Utilizar a imagem gerada pelo `docker-compose.cd-runtime.yml`
- environment: (Informar as variáveis necessárias para deploy da aplicação)
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
    - DESTROY_KUBERNETES_ENVIRONMENT (*default:* `false`) _Realiza `kubectl delete` nos arquivos *.yaml presentes na pasta informado pela variável `$(KUBERNETES_FOLDER)`_
- volumes:
  - COMPOSE_RELEASE_PATH _Informar o caminho dos artefatos gerados no processo de build_

Exemplo:
- [docker-compose.cd-deploy.yml](../docker-compose.cd-deploy.yml)

## Método personalizado

Neste fluxo, ele cria uma imagem publicadora com o propósito de implantar/instalar a sua aplicação em algum ambiente. Aqui nesta etapa, você pode personalizar a publicação da sua aplicação, podendo por exemplo, criar um procedimento que publique sua aplicação para um serviço FTP, S3, etc. É necessário descomentar os stages `deploy` e `final` do *Dockerfile* e realizar a implementação da publicação.

Pré requisitos:
- image: 
  - Utilizar a imagem gerada pelo próprio `docker-compose.yml`

Exemplo:
- Dockerfile
```
[...]

# Utilize o espaço abaixo apenas se você precisar realizar uma publicação customizada de sua aplicação

#---------------Estágio usada para publicação (kubernetes/nuget)
FROM tjmt/publicador:latest as deploy

COPY docker-compose.env* /var/release/source/
COPY --from=build /app/www/ /var/release/www

FROM runtime AS final
```
- [docker-compose.cd-deploy.yml](../docker-compose.cd-deploy-custom.yml)

No exemplo acima, ele está utilizando a própria imagem do `tjmt/publicador` para demonstrar uma outra forma de realizar o deploy da aplicação, ao invés do método convencional. Neste processo, ele deve copiar todos os arquivos `docker-compose.env` para o diretório `/var/release/source/`, visto que, esse é o caminho padrão que o publicador utiliza para converter os arquivos *docker-compose (YML)* para *Kubernetes (YAML)*. Ele também copia os artefatos gerados no build para o diretório `/var/release/www`, este procedimento que serve apenas para visualizar os arquivos gerados no processo de build.
