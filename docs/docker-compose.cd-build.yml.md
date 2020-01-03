# Objetivo

* Responsável por criar uma imagem com a tag `build`, contendo os artefatos de build necessários para o `runtime`.
* Deve passar os argumentos para geração dos artefatos do projeto (pacotes / arquivos runtime)

Pré requisitos:
- tag: `${BRANCH}.${VERSION}-build`
- target: `build`

Exemplo:
- [docker-compose.cd-build.yml](../docker-compose.cd-build.yml)
