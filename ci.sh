# CONTINUOUS INTEGRATION
clear
rm -rf ./docker-extract/
mkdir ./docker-extract/

# Variáveis de configuração geral
export BRANCH=$(echo ${BRANCH:-$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')} | sed 's/refs\/heads\///g' | sed 's/refs\/tags\///g' | sed 's/\//-/g' | sed 's/\./-/g')
export VERSION=${VERSION:-$(date '+%Y%m%d%H%M%S')}
export DOCKER_REGISTRY=${DOCKER_REGISTRY:-}
export DOCKER_LOGIN=${DOCKER_LOGIN:-}
export DOCKER_PASSWORD=${DOCKER_PASSWORD:-}

# Variáveis específicas utilizadas no build
export ARTIFACT_STAGING_DIRECTORY=${ARTIFACT_STAGING_DIRECTORY:-./docker-extract}
export DOCKER_PUSH=${DOCKER_PUSH:-false}
export TARGET=${TARGET-}

# Variáveis utilizadas nos testes
export RUN_LOCAL=${RUN_LOCAL:-false}
export RUN_TEST=${RUN_TEST:-false}
export RUN_SONARQUBE=${RUN_SONARQUBE:-true}
export SONARQUBE_URL=${SONARQUBE_URL:-http://localhost:9000}
export SONARQUBE_LOGIN=${SONARQUBE_LOGIN:-}

# .NET - Variáveis específicas utilizadas nos testes
export DOTNET_TEST_FILTER=${DOTNET_TEST_FILTER:-}

# Angular - Variáveis específicas utilizadas nos testes
export NG_E2E_SPECS=${NG_E2E_SPECS:-./src/features/**/*.feature}
export NG_TEST_SPECS=${NG_TEST_SPECS:-.}

preStage() {
  if [[ -f "ci-pre-$1.sh" ]]; then
    echo ""
    echo "-----------------------------------------------------------------------"
    echo "ci-pre-$1.sh detected"
    echo "Running ci-pre-$1.sh"
    . ci-pre-$1.sh
    echo "-----------------------------------------------------------------------"
  fi
}

postStage() {
  if [[ -f "ci-post-$1.sh" ]]; then
    echo ""
    echo "-----------------------------------------------------------------------"
    echo "ci-post-$1.sh detected"
    echo "Running ci-post-$1.sh"
    . ci-post-$1.sh
    echo "-----------------------------------------------------------------------"
  fi
}

echo "-----------------------------------------------------------------------"
echo "Iniciando ci.sh (Continuous Integration)."
echo "-----------------------------------------------------------------------"

# Tratativa para pegar secret variables da pipeline do VSTS
if [[ -z "$DOCKER_PASSWORD" && ! -z "$1" ]]; then
  export DOCKER_PASSWORD=$1
fi

if [[ ! -z "$DOCKER_REGISTRY" && ! -z "$DOCKER_LOGIN" && ! -z "$DOCKER_PASSWORD" ]]; then
  echo ""
  echo "-----------------------------------------------------------------------"
  echo "Running docker login"
  docker login -u $DOCKER_LOGIN -p $DOCKER_PASSWORD $DOCKER_REGISTRY
  echo "-----------------------------------------------------------------------"
fi

if [[ -z "$TARGET" || "$TARGET" == 'debug' ]]; then
  preStage debug
  echo ""
  echo "-----------------------------------------------------------------------"
  echo "Running docker-compose.ci-debug.yml"
  docker-compose -f "docker-compose.yml" -f "docker-compose.ci-debug.yml" build
  echo "-----------------------------------------------------------------------"
  postStage debug
  
  if [[ "$TARGET" == 'debug' ]]; then
    exit 0
  fi
fi

if [[ -z "$TARGET" || "$TARGET" == 'tests' ]]; then
  preStage tests
  echo ""
  echo "-----------------------------------------------------------------------"
  echo "Running docker-compose.ci-tests.yml"
  docker-compose -f "docker-compose.yml" -f "docker-compose.ci-tests.yml" up --build --force-recreate --abort-on-container-exit
  echo "-----------------------------------------------------------------------"
  postStage tests

  echo ""
  echo "-----------------------------------------------------------------------"
  echo "Extraindo os artefatos de teste"
  docker cp tests-cnj-jus-br:/TestResults ${ARTIFACT_STAGING_DIRECTORY}/TestResults
  echo "-----------------------------------------------------------------------"

  if [[ "$TARGET" == 'tests' ]]; then
    exit 0
  fi
fi

preStage build
echo ""
echo "-----------------------------------------------------------------------"
echo "Running docker-compose.ci-build.yml"
docker-compose -f "docker-compose.yml" -f "docker-compose.ci-build.yml" up --build --force-recreate --no-start
echo "-----------------------------------------------------------------------"
postStage build

echo ""
echo "-----------------------------------------------------------------------"
echo "Extraindo os artefatos de build"
docker cp build-cnj-jus-br:/app ${ARTIFACT_STAGING_DIRECTORY}/BuildArtifacts
echo "-----------------------------------------------------------------------"

preStage runtime
echo ""
echo "-----------------------------------------------------------------------"
echo "Running docker-compose.ci-runtime.yml"
docker-compose -f "docker-compose.yml" -f "docker-compose.ci-runtime.yml" build
echo "-----------------------------------------------------------------------"
postStage runtime

# preStage deploy
# echo ""
# echo "-----------------------------------------------------------------------"
# echo "Running docker-compose.ci-deploy.yml"
# docker-compose -f "docker-compose.yml" -f "docker-compose.ci-deploy.yml" build
# echo "-----------------------------------------------------------------------"
# postStage deploy

if [[ "$DOCKER_PUSH" == 'true' ]]; then
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
echo "Running docker-compose down"
docker-compose -f "docker-compose.yml" -f "docker-compose.ci-debug.yml" down -v --rmi local --remove-orphans
docker-compose -f "docker-compose.yml" -f "docker-compose.ci-tests.yml" down -v --rmi local --remove-orphans
docker-compose -f "docker-compose.yml" -f "docker-compose.ci-build.yml" down -v --rmi local --remove-orphans
docker-compose -f "docker-compose.yml" -f "docker-compose.ci-runtime.yml" down -v --rmi local --remove-orphans
# docker-compose -f "docker-compose.yml" -f "docker-compose.ci-deploy.yml" down -v --rmi local --remove-orphans
echo "-----------------------------------------------------------------------"

echo $VERSION > $ARTIFACT_STAGING_DIRECTORY/BuildArtifacts/source/version