# Objetivo

* Responsável por criar uma imagem com o propósito de depuração de código. Aqui nesta etapa, os artefatos de build não são otimizados para rodar em ambiente de produção, devendo ser utilizado apenas em ambiente de teste.

Pré requisitos:
- tag: `${BRANCH}.${VERSION}`
- target: `debug`

Exemplo:
- [docker-compose.ci-debug.yml](../docker-compose.ci-debug.yml)
