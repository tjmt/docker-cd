# CONTINUOUS DELIVERY
# IMPORTANTE: Caso você utilize Git Bash (Windows) como linha de comando, execute o script com 'MSYS_NO_PATHCONV=1' como prefixo.
# Exemplo: MSYS_NO_PATHCONV=1 . cd.sh
clear

# Variáveis de configuração geral
export BRANCH=$(echo ${BRANCH:-$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')} | sed 's/refs\/heads\///g' | sed 's/refs\/tags\///g' | sed 's/\//-/g')
export DOCKER_REGISTRY=${DOCKER_REGISTRY:-}
export DOCKER_LOGIN=${DOCKER_LOGIN:-}
export DOCKER_PASSWORD=${DOCKER_PASSWORD:-}
export DOCKER_SERVICES=${DOCKER_SERVICES:-}

# Variável que define o ambiente em que será realizado o deploy
export DEPLOY_ENVIRONMENT=$(echo ${DEPLOY_ENVIRONMENT:-alpha} | tr '[:upper:]' '[:lower:]')

# Kubernetes - Variáveis específicas utilizadas no publicador
export DEPLOY_KUBERNETES=${DEPLOY_KUBERNETES:-true}
export DESTROY_KUBERNETES_ENVIRONMENT=${DESTROY_KUBERNETES_ENVIRONMENT:-false}
export COMPOSE_PATH=docker-compose.env-${DEPLOY_ENVIRONMENT}.yml
export KUBECONFIG_PATH=${KUBECONFIG_PATH:-/entrypoint/kubernetes/kubeconfig/dev}
export COMPOSE_RELEASE_PATH=${COMPOSE_RELEASE_PATH:-./docker-extract/BuildArtifacts}

# NPM - Variáveis específicas utilizadas no publicador
export DEPLOY_NPM=${DEPLOY_NPM:-false}
export NPM_PACKAGES_FOLDER=${NPM_PACKAGES_FOLDER:-/var/release/packages/npm}
export NPM_REGISTRY=${NPM_REGISTRY:-}
export NPM_EMAIL=${NPM_EMAIL:-}
export NPM_USER=${NPM_USER}
export NPM_PASS=${NPM_PASS}

# Nuget - Variáveis específicas utilizadas no publicador
export DEPLOY_NUGET=${DEPLOY_NUGET:-false}
export NUGET_PACKAGES_FOLDER=${NUGET_PACKAGES_FOLDER:-/var/release/packages/nuget}
export NUGET_REGISTRY=${NUGET_REGISTRY:-}
export NUGET_USER=${NUGET_USER}
export NUGET_PASS=${NUGET_PASS}
export NUGET_APIKEY=${NUGET_APIKEY}

# Tratamento do lifecycle 'stable' para os pacotes NPM/Nuget
if [[ $DEPLOY_ENVIRONMENT != "stable" ]]; then
  export NPM_LIFECYCLE_VERSION=${DEPLOY_ENVIRONMENT}
  export NUGET_LIFECYCLE_VERSION=${DEPLOY_ENVIRONMENT}
fi

# Tratamento do nome da branch para o DNS e artefatos Kubernetes utilizado no ambiente ALPHA
export BRANCH_DNS=$(echo ${BRANCH} | sed 's/\./-/g')

# Tratamento para capturar a versão dos artefatos de build
export VERSION=${VERSION:-$(cat $COMPOSE_RELEASE_PATH/source/version)}

preStage() {
  if [[ -f "cd-pre-$1.sh" ]]; then
    echo ""
    echo "-----------------------------------------------------------------------"
    echo "cd-pre-$1.sh detected"
    echo "Running cd-pre-$1.sh"
    . cd-pre-$1.sh
    echo "-----------------------------------------------------------------------"
  fi
}

postStage() {
  if [[ -f "cd-post-$1.sh" ]]; then
    echo ""
    echo "-----------------------------------------------------------------------"
    echo "cd-post-$1.sh detected"
    echo "Running cd-post-$1.sh"
    . cd-post-$1.sh
    echo "-----------------------------------------------------------------------"
  fi
}

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

preStage release
echo ""
echo "-----------------------------------------------------------------------"
echo "Publicação em ambiente ${DEPLOY_ENVIRONMENT}"
docker-compose -f "docker-compose.cd-release.yml" up --abort-on-container-exit $DOCKER_SERVICES
docker-compose -f "docker-compose.cd-release.yml" down --rmi local -v --remove-orphans
echo "-----------------------------------------------------------------------"
postStage release

echo "-----------------------------------------------------------------------"
echo "URLs das aplicações publicadas:"
eval echo $(grep -oP '(?<=kompose.service.expose: ).*' ${COMPOSE_RELEASE_PATH}/source/docker-compose.env-${DEPLOY_ENVIRONMENT}.yml)
echo "-----------------------------------------------------------------------"