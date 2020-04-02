# CONTINUOUS INTEGRATION
clear
rm -rf ./docker-extract/
mkdir ./docker-extract/

# Variáveis de configuração geral
export BRANCH=$(echo ${BRANCH:-$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')} | sed 's/refs\/heads\///g' | sed 's/refs\/tags\///g' | sed 's/\//-/g' | sed 's/\./-/g')
export VERSION=${VERSION:-$(date '+%Y%m%d')-1}
export DOCKER_REGISTRY=${DOCKER_REGISTRY:-}
export DOCKER_LOGIN=${DOCKER_LOGIN:-}
export DOCKER_PASSWORD=${DOCKER_PASSWORD:-}

# Variáveis específicas utilizadas no build
export ARTIFACT_STAGING_DIRECTORY=${ARTIFACT_STAGING_DIRECTORY:-./docker-extract}
export DOCKER_PUSH=${DOCKER_PUSH:-false}
export RUN_LOCAL=${RUN_LOCAL:-true}

# Variáveis utilizadas nos testes
export RUN_TEST=${RUN_TEST:-false}
export RUN_SONARQUBE=${RUN_SONARQUBE:-true}
export SONARQUBE_URL=${SONARQUBE_URL:-http://localhost:9000}
export SONARQUBE_LOGIN=${SONARQUBE_LOGIN:-}

# .NET - Variáveis específicas utilizadas nos testes
export DOTNET_TEST_FILTER=${DOTNET_TEST_FILTER:-}

# Angular - Variáveis específicas utilizadas nos testes
export NG_E2E_SPECS=${NG_E2E_SPECS:-./src/features/**/*.feature}
export NG_TEST_SPECS=${NG_TEST_SPECS:-.}

echo "-----------------------------------------------------------------------"
echo "Iniciando ci.sh (Continuous Integration)."
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

if [[ $RUN_LOCAL == 'true' ]]; then
  echo ""
  echo "-----------------------------------------------------------------------"
  echo "Run docker-compose.override.yml"
  docker-compose -f "docker-compose.yml" -f "docker-compose.override.yml" up --build
  echo "-----------------------------------------------------------------------"

  exit 0
fi

if [[ $RUN_TEST == 'true' ]]; then
    echo ""
    echo "-----------------------------------------------------------------------"
    echo "Run docker-compose.ci-tests.yml"
    docker-compose -f "docker-compose.yml" -f "docker-compose.ci-tests.yml" up --build --force-recreate --abort-on-container-exit
    echo "-----------------------------------------------------------------------"

    echo ""
    echo "-----------------------------------------------------------------------"
    echo "Extraindo os artefatos de teste"
    docker cp tests-cnj-jus-br:/TestResults ${ARTIFACT_STAGING_DIRECTORY}/TestResults
    echo "-----------------------------------------------------------------------"
fi

echo ""
echo "-----------------------------------------------------------------------"
echo "Run docker-compose.ci-debug.yml"
docker-compose -f "docker-compose.yml" -f "docker-compose.ci-debug.yml" build
echo "-----------------------------------------------------------------------"

echo ""
echo "-----------------------------------------------------------------------"
echo "Run docker-compose.ci-build.yml"
docker-compose -f "docker-compose.yml" -f "docker-compose.ci-build.yml" up --build --force-recreate --no-start
echo "-----------------------------------------------------------------------"

echo ""
echo "-----------------------------------------------------------------------"
echo "Extraindo os artefatos de build"
docker cp build-cnj-jus-br:/app ${ARTIFACT_STAGING_DIRECTORY}/BuildArtifacts
echo "-----------------------------------------------------------------------"

echo ""
echo "-----------------------------------------------------------------------"
echo "Run docker-compose.ci-runtime.yml"
docker-compose -f "docker-compose.yml" -f "docker-compose.ci-runtime.yml" build
echo "-----------------------------------------------------------------------"

# echo ""
# echo "-----------------------------------------------------------------------"
# echo "Run docker-compose.ci-deploy.yml"
# docker-compose -f "docker-compose.yml" -f "docker-compose.ci-deploy.yml" build
# echo "-----------------------------------------------------------------------"

if [[ $DOCKER_PUSH == 'true' ]]; then
  echo ""
  echo "-----------------------------------------------------------------------"
  echo "Docker push to registry"
  docker-compose -f "docker-compose.yml" -f "docker-compose.ci-debug.yml" push
  docker-compose -f "docker-compose.yml" -f "docker-compose.ci-runtime.yml" push
  # docker-compose -f "docker-compose.yml" -f "docker-compose.ci-deploy.yml" push
  echo "-----------------------------------------------------------------------"
fi

echo ""
echo "-----------------------------------------------------------------------"
echo "Remoção de todas as imagens de build juntamente com os seus respectivos volumes e imagens intermediárias"
docker-compose -f "docker-compose.yml" -f "docker-compose.ci-tests.yml" down -v --rmi all --remove-orphans
docker-compose -f "docker-compose.yml" -f "docker-compose.ci-debug.yml" down -v --rmi all --remove-orphans
docker-compose -f "docker-compose.yml" -f "docker-compose.ci-build.yml" down -v --rmi all --remove-orphans
docker-compose -f "docker-compose.yml" -f "docker-compose.ci-runtime.yml" down -v --rmi all --remove-orphans
# docker-compose -f "docker-compose.yml" -f "docker-compose.ci-deploy.yml" down -v --rmi all --remove-orphans
echo "-----------------------------------------------------------------------"
