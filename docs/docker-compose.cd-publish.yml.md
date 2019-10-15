> Responsável por conter os argumentos para geração dos artefatos do projeto (pacotes/ arquivos runtime)

Pré requisitos:
- tag: `${BRANCH}.${VERSION}-publish`
- target: `release`
- args:
    - VERSION: Versão da imagem
    - BRANCH: Nome da branch
- volume
    - Criar um volume mapeando para a pasta com os artefatos criados
        - Pasta padrão (`/var/release/`)
        - Nomear usando variavel de ambiente: `${DOCKERCOMPOSE_PUBLISH_VOLUME_NAME}`    

```yml
version: '3.5'

services:
  sistema-tjmt-jus-br:
    image: ${DOCKER_REGISTRY}sistema.tjmt.jus.br:${BRANCH:-develop}.${VERSION:-local}-publish
    container_name: sistema-${BRANCH:-develop}-publish.tjmt.jus.br
    build:
      target: release
      args:
        VERSION: ${VERSION:-local}
        BRANCH: ${BRANCH:-develop}
    volumes:
      - app:/var/release/

volumes:
  app:
    name: ${DOCKERCOMPOSE_PUBLISH_VOLUME_NAME:-sistema-extract-app}
```