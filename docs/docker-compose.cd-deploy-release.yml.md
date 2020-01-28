# Objetivo

* Responsável pelo deploy dos artefatos à partir de uma imagem gerada pelo processo de build do `docker-compose.cd-deploy-build.yml`. É necessário descomentar o stage `deploy` do Dockerfile.

Pré requisitos:
- image: 
  - Utilizar a mesma imagem gerada pelo `docker-compose.cd-deploy-build.yml`

Exemplo:

  No protótipo abaixo, ele está utilizando a própria imagem do `tjmt/publicador` para demonstrar uma outra forma de realizar deploy de uma aplicação, ao invés de usar o [docker-compose.cd-deploy.yml](docker-compose.cd-deploy.yml.md). Na situação em questão, ele copia todos os arquivos `docker-compose.env` para o diretório `/var/release/source/`, porque esse é o caminho padrão que o publicador utiliza para converter os arquivos docker-compose (YML) para Kubernetes (YAML). Ele também copia os artefatos gerados no build para o diretório `/var/release/www`, este procedimento serve apenas para visualizar os arquivos gerados no processo de build.

- [docker-compose.cd-deploy-release.yml](../docker-compose.cd-deploy-release.yml)
