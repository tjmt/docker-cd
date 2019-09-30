
##-------------- RELEASE

export DOCKER_REGISTRY=nexusdocker.tjmt.jus.br
export VERSION=20190927-1
export BRANCH=feature-1

export DEPLOY_NUGET="true"
export DEPLOY_KUBERNETES="true"
export DESTROY_KUBERNETES_ENVIRONMENT="false"
export NUGET_LIFECYCLE_VERSION=dev
export KUBERNETES_FOLDER="/var/release/source"

echo "---------Publico a imagem final em dev"
export KUBECONFIG_PATH=""
export COMPOSE_PATH
docker-compose -f "docker-compose.cd-release.yml" up --build --abort-on-container-exit
docker-compose -f "docker-compose.cd-release.yml" down

# echo "---------Publico a imagem final em stage"
# export NUGET_LIFECYCLE_VERSION=stage
# docker-compose -f "docker-compose.cd-release.yml" up --abort-on-container-exit
# docker-compose -f "docker-compose.cd-release.yml" down

# echo "---------Publico a imagem final em prod"
# export NUGET_LIFECYCLE_VERSION=""
# docker-compose -f "docker-compose.cd-release.yml" up --abort-on-container-exit
# docker-compose -f "docker-compose.cd-release.yml" down