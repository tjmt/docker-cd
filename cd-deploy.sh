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
export VERSION=$(date '+%Y%m%d')-1
export BRANCH="develop"
export COMPOSE_PATH="" #Direfente para cada ambiente


echo "---------Publico em alpha"
export NUGET_LIFECYCLE_VERSION="alpha"
export NPM_LIFECYCLE_VERSION="alpha"
#export KUBECONFIG_PATH=""
export COMPOSE_PATH="docker-compose.env-alpha.yml"
docker-compose -f "docker-compose.cd-deploy.yml" up --abort-on-container-exit
docker-compose -f "docker-compose.cd-deploy.yml" down
echo "-------------------------------------"

echo "---------Publico em beta"
export NUGET_LIFECYCLE_VERSION="beta"
export NPM_LIFECYCLE_VERSION="beta"
#export KUBECONFIG_PATH=""
export COMPOSE_PATH="docker-compose.env-beta.yml"
docker-compose -f "docker-compose.cd-deploy.yml" up --abort-on-container-exit
docker-compose -f "docker-compose.cd-deploy.yml" down
echo "-------------------------------------"


echo "---------Publico em rc"
export NUGET_LIFECYCLE_VERSION="rc"
export NPM_LIFECYCLE_VERSION="rc"
#export KUBECONFIG_PATH=""
export COMPOSE_PATH="docker-compose.env-rc.yml"
docker-compose -f "docker-compose.cd-deploy.yml" up --abort-on-container-exit
docker-compose -f "docker-compose.cd-deploy.yml" down
echo "-------------------------------------"


echo "---------Publico em prod (stable)"
export NUGET_LIFECYCLE_VERSION=""
export NPM_LIFECYCLE_VERSION=""
#export KUBECONFIG_PATH=""
export COMPOSE_PATH="docker-compose.env-stable.yml"
docker-compose -f "docker-compose.cd-deploy.yml" up --abort-on-container-exit
docker-compose -f "docker-compose.cd-deploy.yml" down
echo "-------------------------------------"
