Responsável por conter as configurações (variáveis de ambiente, labels, etc) e imagem a ser utilizada para a publicação em um ambiente específico.
> Pode-se haver múltiplos arquivos que será utilizado pela ferramenta de automação para criar/publicar no ambiente específico.
>

Exemplos:


<details>
  <summary>docker-compose.dev.yml</summary>

  ```yml
  version: '3.5'

services:
  sistema-tjmt-jus-br:
    image: ${DOCKER_REGISTRY}sistema.tjmt.jus.br:${BRANCH:-develop}.${VERSION:-local}-build
    environment:
      RUN_TEST: ${RUN_TEST:-false}
      RUN_PROJECT: ${RUN_PROJECT:-true}
    deploy:
      replicas: 2
      resources:
        limits:
          cpus: '0.1'
          memory: 512M
        reservations:
          cpus: '0.1'
          memory: 128M         
    ports:
      - 80:4200
    labels:
      kompose.service.expose: sistema-${BRANCH:-develop}-dev.tjmt.jus.br

  sistema-api-tjmt-jus-br:
    image: suhailtaj/mock-api:${SISTEMA_API_VERSION:-latest}
    command: /usr/data/db.json
    volumes:
      - ./data/db.json:/usr/data/db.json
    ports:
      - 80:9090
    labels:
      kompose.service.expose: sistema-api-${BRANCH:-develop}-dev.tjmt.jus.br

networks:
  default:
    name: ns-sistema-${BRANCH:-develop}-dev

  ```
</details>

<details>
  <summary>docker-compose.qa.yml</summary>

  ```yml
  version: '3.5'

services:
  sistema-tjmt-jus-br:
    image: ${DOCKER_REGISTRY}sistema.tjmt.jus.br:${BRANCH:-develop}.${VERSION:-local}
    ports:
      - 80:80
      - 443:443
    deploy:
      replicas: 2
      resources:
        limits:
          cpus: '0.1'
          memory: 512M
        reservations:
          cpus: '0.1'
          memory: 128M         
    labels:
      kompose.service.expose: sistema-${BRANCH:-develop}-qa.tjmt.jus.br

networks:
  default:
    name: ns-sistema-${BRANCH:-develop}-qa

  ```
</details>

<details>
  <summary>docker-compose.stage.yml</summary>

  ```yml
  version: '3.5'

services:
  sistema-tjmt-jus-br:
    image: ${DOCKER_REGISTRY}sistema.tjmt.jus.br:${BRANCH:-develop}.${VERSION:-local}
    ports:
      - 80:80
      - 443:443
    deploy:
      replicas: 2
      resources:
        limits:
          cpus: '0.1'
          memory: 512M
        reservations:
          cpus: '0.1'
          memory: 128M         
    labels:
      kompose.service.expose: sistema-stage.tjmt.jus.br

networks:
  default:
    name: ns-sistema-stage

  ```
</details>


<details>
  <summary>docker-compose.prod.yml</summary>

  ```yml
  version: '3.5'

services:
  sistema-tjmt-jus-br:
    image: ${DOCKER_REGISTRY}sistema.tjmt.jus.br:${BRANCH}.${VERSION}
    ports:
      - 80:80
      - 443:443
    deploy:
      replicas: 2
      resources:
        limits:
          cpus: '0.1'
          memory: 512M
        reservations:
          cpus: '0.1'
          memory: 128M        
    labels:
      kompose.service.expose: sistema.tjmt.jus.br

networks:
  default:
    name: ns-sistema

  ```
</details>