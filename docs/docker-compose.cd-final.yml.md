> Responsável por conter os argumentos e serviços necessários para executar o projeto em versão final.

Pré requisitos:
- tag: `${BRANCH}.${VERSION}`
- target: `final`

<details>
  <summary>Exemplo</summary>

```yml
version: '3.5'

services:
  sistema-tjmt-jus-br:
    image: ${DOCKER_REGISTRY}sistema.tjmt.jus.br:${BRANCH:-develop}.${VERSION:-local}
    build:
      target: final

```
</details>  