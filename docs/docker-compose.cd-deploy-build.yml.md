# Objetivo

* Responsável por criar uma imagem que terá o propósito de implantar/instalar a sua aplicação em algum ambiente. Aqui nesta etapa, você pode personalizar a publicação da sua aplicação, podendo, por exemplo, criar um procedimento que publique sua aplicação via FTP, S3, etc. É necessário descomentar o stage `deploy` do Dockerfile.

Pré requisitos:
- tag: `${BRANCH}.${VERSION}`
- target: `deploy`

Exemplo:
- [docker-compose.cd-deploy-build.yml](../docker-compose.cd-deploy-build.yml)
