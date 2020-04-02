# CONTINUOUS DELIVERY
# IMPORTANTE: Caso você utilize Git Bash (Windows) como linha de comando execute este script com 'MSYS_NO_PATHCONV=1' como prefixo.
# Exemplo: MSYS_NO_PATHCONV=1 ./cd-RELEASE.sh
clear

# Variáveis de configuração geral
export BRANCH=$(echo ${BRANCH:-$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')} | sed 's/refs\/heads\///g' | sed 's/refs\/tags\///g' | sed 's/\//-/g')
export VERSION=${VERSION:-$(date '+%Y%m%d')-1}
export DOCKER_REGISTRY=${DOCKER_REGISTRY:-}
export DOCKER_LOGIN=${DOCKER_LOGIN:-}
export DOCKER_PASSWORD=${DOCKER_PASSWORD:-}

# Variável que define o ambiente em que será realizado o deploy
export DEPLOY_ENVIRONMENT=$(echo ${DEPLOY_ENVIRONMENT:-alpha} | tr '[:upper:]' '[:lower:]')

# Kubernetes - Variáveis específicas utilizadas no publicador
export DEPLOY_KUBERNETES=${DEPLOY_KUBERNETES:-true}
export DESTROY_KUBERNETES_ENVIRONMENT=${DESTROY_KUBERNETES_ENVIRONMENT:-false}
export COMPOSE_PATH=docker-compose.env-${DEPLOY_ENVIRONMENT}.yml
export KUBECONFIG_PATH=${KUBECONFIG_PATH:-}
export COMPOSE_RELEASE_PATH=${COMPOSE_RELEASE_PATH:-./docker-extract/BuildArtifacts/source}

# NPM - Variáveis específicas utilizadas no publicador
export DEPLOY_NPM=${DEPLOY_NPM:-false}
export NPM_REGISTRY=${NPM_REGISTRY:-}
export NPM_EMAIL=${NPM_EMAIL:-}
export NPM_USER=${NPM_USER}
export NPM_PASS=${NPM_PASS}
export NPM_PACKAGES_FOLDER=${NPM_PACKAGES_FOLDER:-/var/release/packages/npm}

# Nuget - Variáveis específicas utilizadas no publicador
export DEPLOY_NUGET=${DEPLOY_NUGET:-false}
export NUGET_REGISTRY=${NUGET_REGISTRY:-}
export NUGET_USER=${NUGET_USER}
export NUGET_PASS=${NUGET_PASS}
export NUGET_PACKAGES_FOLDER=${NUGET_PACKAGES_FOLDER:-/var/release/packages/nuget}

# Tratamento do lifecycle 'stable' para os pacotes NPM/Nuget
if [[ $DEPLOY_ENVIRONMENT != "stable" ]]; then
  export NPM_LIFECYCLE_VERSION=${DEPLOY_ENVIRONMENT}
  export NUGET_LIFECYCLE_VERSION=${DEPLOY_ENVIRONMENT}
fi

# Tratamento do nome da branch para o DNS e artefatos Kubernetes utilizado no ambiente ALPHA
export BRANCH_DNS=$(echo ${BRANCH} | sed 's/\./-/g')

echo "-----------------------------------------------------------------------"
echo "Iniciando cd.sh (Continuous Delivery)."
echo "-----------------------------------------------------------------------"

# Tratativa para pegar secret variables da pipeline do VSTS
if [[ -z $DOCKER_PASSWORD && ! -z "$1" ]]; then
  export DOCKER_PASSWORD=$1
fi

if [[ ! -z $DOCKER_REGISTRY && ! -z $DOCKER_LOGIN && ! -z $DOCKER_PASSWORD ]]; then
  echo ""
  echo "-----------------------------------------------------------------------"
  echo "Run docker login"
  docker login -u $DOCKER_LOGIN -p $DOCKER_PASSWORD $DOCKER_REGISTRY
  echo "-----------------------------------------------------------------------"
fi

echo ""
echo "-----------------------------------------------------------------------"
echo "Publicação em ambiente ${DEPLOY_ENVIRONMENT}"
docker-compose -f "docker-compose.cd-release.yml" up --abort-on-container-exit
docker-compose -f "docker-compose.cd-release.yml" down --rmi local -v --remove-orphans
echo "-----------------------------------------------------------------------"
