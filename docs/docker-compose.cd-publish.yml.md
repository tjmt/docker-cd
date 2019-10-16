# Objetivo

* Responsável por criar uma imagem com a tag `publish`, contendo os arquivos finais para `release`.
* Deve passar os argumentos para geração dos artefatos do projeto (pacotes/ arquivos runtime)

Pré requisitos:
- tag: `${BRANCH}.${VERSION}-publish`
- target: `release`
- args:
    - `VERSION`: Versão da imagem
    - `BRANCH`: Nome da branch
- volume
    - Criar um volume mapeando para a pasta com os artefatos criados
        - Pasta padrão (`/var/release/`)
        - Nomear usando variavel de ambiente: `${DOCKERCOMPOSE_PUBLISH_VOLUME_NAME}`    

Exemplo:
- [docker-compose.cd-publish.yml](../docker-compose.cd-publish.yml)