# Objetivo

> Responsável por criar a sua própria imagem de publicação contendo a tag `deploy`. Ela só deve ser utilizada com um compose de release customizado. *Vide [docker-compose.cd-release-custom.yml](docker-compose.cd-release.yml.md#método-personalizado)*

Pré requisitos:
- tag: `${BRANCH}.${VERSION}-deploy`
- target: `deploy`

Exemplo:
- [docker-compose.ci-deploy.yml](../docker-compose.ci-deploy.yml)