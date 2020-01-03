# RELEASE
# IMPORTANTE: Caso você utilize Git Bash (Windows) como linha de comando execute este script com 'MSYS_NO_PATHCONV=1' como prefixo.
# Exemplo: MSYS_NO_PATHCONV=1 ./cd-RELEASE.sh
clear

# Variáveis de configuração geral
export DOCKER_REGISTRY=""
export VERSION=$(date '+%Y%m%d')-1
export BRANCH="develop"

# Caminho dos artefatos de build
export COMPOSE_RELEASE_PATH="./docker-extract/BuildArtifacts/source/"

# NPM
export DEPLOY_NPM="false"
export NPM_PACKAGES_FOLDER="/var/release/packages/npm"
export NPM_LIFECYCLE_VERSION="" # Direfente para cada ambiente
export NPM_REGISTRY=""
export NPM_USER=""
export NPM_PASS=""
export NPM_EMAIL=""

# Nuget
export DEPLOY_NUGET="false"
export NUGET_PACKAGES_FOLDER="/var/release/packages/nuget"
export NUGET_LIFECYCLE_VERSION="" # Direfente para cada ambiente
export NUGET_REGISTRY=""
export NUGET_USER=""
export NUGET_PASS=""

# Kubernetes
export DEPLOY_KUBERNETES="true"
export DESTROY_KUBERNETES_ENVIRONMENT="false"
export KUBERNETES_FOLDER="/var/release/source"
export KUBECONFIG_PATH="/var/release/source/kubeconfig"

# Kompose
export DOCKER_REGISTRY=""
export VERSION=$(date '+%Y%m%d')-1
export BRANCH="develop"
export COMPOSE_PATH="" # Direfente para cada ambiente

echo "-----------------------------------------------------------------------"
echo "Iniciando cd-RELEASE.sh."
echo "ImageName: ${DOCKER_REGISTRY}/app:${BRANCH}.${VERSION}"
echo "-----------------------------------------------------------------------"

echo ""
echo "-----------------------------------------------------------------------"
echo "Publicação em ambiente ALPHA"
export COMPOSE_PATH="docker-compose.env-alpha.yml"
export KUBECONFIG_PATH=""
export NPM_LIFECYCLE_VERSION="alpha"
export NUGET_LIFECYCLE_VERSION="alpha"
docker-compose -f "docker-compose.cd-deploy.yml" up --abort-on-container-exit
docker-compose -f "docker-compose.cd-deploy.yml" down --rmi all -v --remove-orphans
echo "-----------------------------------------------------------------------"

echo ""
echo "-----------------------------------------------------------------------"
echo "Publicação em ambiente BETA"
export COMPOSE_PATH="docker-compose.env-beta.yml"
export KUBECONFIG_PATH=""
export NPM_LIFECYCLE_VERSION="beta"
export NUGET_LIFECYCLE_VERSION="beta"
docker-compose -f "docker-compose.cd-deploy.yml" up --abort-on-container-exit
docker-compose -f "docker-compose.cd-deploy.yml" down --rmi all -v --remove-orphans
echo "-----------------------------------------------------------------------"

echo ""
echo "-----------------------------------------------------------------------"
echo "Publicação em ambiente RC"
export COMPOSE_PATH="docker-compose.env-rc.yml"
export KUBECONFIG_PATH=""
export NPM_LIFECYCLE_VERSION="rc"
export NUGET_LIFECYCLE_VERSION="rc"
docker-compose -f "docker-compose.cd-deploy.yml" up --abort-on-container-exit
docker-compose -f "docker-compose.cd-deploy.yml" down --rmi all -v --remove-orphans
echo "-----------------------------------------------------------------------"

echo ""
echo "-----------------------------------------------------------------------"
echo "Publicação em ambiente STABLE"
export COMPOSE_PATH="docker-compose.env-stable.yml"
export KUBECONFIG_PATH=""
export NPM_LIFECYCLE_VERSION=""
export NUGET_LIFECYCLE_VERSION=""
docker-compose -f "docker-compose.cd-deploy.yml" up --abort-on-container-exit
docker-compose -f "docker-compose.cd-deploy.yml" down --rmi all -v --remove-orphans
echo "-----------------------------------------------------------------------"


---------------------------


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
