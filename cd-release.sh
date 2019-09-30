##-------------- RELEASE


#----Nuget
export DEPLOY_NUGET="false"
export NUGET_PACKAGES_FOLDER="/var/release/packages/nuget"
export NUGET_LIFECYCLE_VERSION="" #Direfente para cada ambiente
export NUGET_REGISTRY=""
export NUGET_USER=""
export NUGET_PASS=""

#----NPM
export DEPLOY_NPM="false"
export NPM_PACKAGES_FOLDER="/var/release/packages/npm"
export NPM_LIFECYCLE_VERSION="" #Direfente para cada ambiente
export NPM_REGISTRY=""
export NPM_USER=""
export NPM_PASS=""
export NPM_EMAIL=""

#----Kubernetes
export DEPLOY_KUBERNETES="true"
export DESTROY_KUBERNETES_ENVIRONMENT="false"
export KUBERNETES_FOLDER="/var/release/source"
export KUBECONFIG_PATH="/var/release/source/kubeconfig"


 #----Kompose
export DOCKER_REGISTRY=""
export VERSION="20190927-1"
export BRANCH="feature-1"
export COMPOSE_PATH="" #Direfente para cada ambiente


echo "---------Publico a imagem final em dev"
export NUGET_LIFECYCLE_VERSION="alpha"
export NPM_LIFECYCLE_VERSION="alpha"
export KUBECONFIG_PATH=""
export COMPOSE_PATH="docker-compose.dev.yml"
docker-compose -f "docker-compose.cd-release.yml" up --abort-on-container-exit
docker-compose -f "docker-compose.cd-release.yml" down
echo "-------------------------------------"


echo "---------Publico a imagem final em stage"
export NUGET_LIFECYCLE_VERSION="rc"
export NPM_LIFECYCLE_VERSION="rc"
export KUBECONFIG_PATH=""
export COMPOSE_PATH="docker-compose.stage.yml"
docker-compose -f "docker-compose.cd-release.yml" up --abort-on-container-exit
docker-compose -f "docker-compose.cd-release.yml" down
echo "-------------------------------------"


echo "---------Publico a imagem final em prod"
export NUGET_LIFECYCLE_VERSION=''
export NPM_LIFECYCLE_VERSION=""
export KUBECONFIG_PATH=""
export COMPOSE_PATH="docker-compose.stage.yml"
docker-compose -f "docker-compose.cd-release.yml" up --abort-on-container-exit
docker-compose -f "docker-compose.cd-release.yml" down
echo "-------------------------------------"