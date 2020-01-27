# Objetivo

* Responsável pelo deploy dos artefatos à partir de uma imagem gerada pelo processo de build do `docker-compose.cd-deploy-build.yml`. É necessário descomentar o stage `deploy` do Dockerfile.

Pré requisitos:
- image: 
  - Utilizar a mesma imagem gerada pelo `docker-compose.cd-deploy-build.yml`

Exemplo:
- [docker-compose.cd-deploy-release.yml](../docker-compose.cd-deploy-release.yml)
