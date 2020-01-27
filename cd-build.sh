# BUILD
clear
rm -rf ./docker-extract/
mkdir ./docker-extract/

# Variáveis de configuração geral
export DOCKER_REGISTRY=""
export VERSION=$(date '+%Y%m%d')-1
export BRANCH="develop"

# Variáveis utilizadas nos testes
export RUN_TEST="true"
export RUN_SONARQUBE="true"
export SONARQUBE_URL="http://localhost:9000"
export SONARQUBE_LOGIN=""

# Variáveis utilizadas para extrair os artefatos de container
export ARTIFACT_STAGING_DIRECTORY="./docker-extract"

echo "-----------------------------------------------------------------------"
echo "Iniciando cd-BUILD.sh."
echo "ImageName: ${DOCKER_REGISTRY}/app:${BRANCH}.${VERSION}"
echo "-----------------------------------------------------------------------"

if [[ $RUN_TEST == 'true' ]]; then
    echo ""
    echo "-----------------------------------------------------------------------"
    echo "Run docker-compose.cd-tests.yml"
    docker-compose -f "docker-compose.yml" -f "docker-compose.cd-tests.yml" up --build --force-recreate --abort-on-container-exit
    echo "-----------------------------------------------------------------------"

    echo ""
    echo "-----------------------------------------------------------------------"
    echo "Extraindo os artefatos de teste"
    docker cp tests-tjmt-jus-br:/TestResults ${ARTIFACT_STAGING_DIRECTORY}/TestResults
    echo "-----------------------------------------------------------------------"
fi

echo ""
echo "-----------------------------------------------------------------------"
echo "Run docker-compose.cd-debug.yml"
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-debug.yml" build
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-debug.yml" push
echo "-----------------------------------------------------------------------"

echo ""
echo "-----------------------------------------------------------------------"
echo "Run docker-compose.cd-build.yml"
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-build.yml" up --build --force-recreate --no-start
echo "-----------------------------------------------------------------------"

echo ""
echo "-----------------------------------------------------------------------"
echo "Extraindo os artefatos de build"
docker cp build-tjmt-jus-br:/app ${ARTIFACT_STAGING_DIRECTORY}/BuildArtifacts
echo "-----------------------------------------------------------------------"

echo ""
echo "-----------------------------------------------------------------------"
echo "Run docker-compose.cd-runtime.yml"
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-runtime.yml" build
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-runtime.yml" push
echo "-----------------------------------------------------------------------"

# echo ""
# echo "-----------------------------------------------------------------------"
# echo "Run docker-compose.cd-deploy-build.yml"
# docker-compose -f "docker-compose.yml" -f "docker-compose.cd-deploy-build.yml" build
# docker-compose -f "docker-compose.yml" -f "docker-compose.cd-deploy-build.yml" push
# echo "-----------------------------------------------------------------------"

echo ""
echo "-----------------------------------------------------------------------"
echo "Remoção de todas as imagens de build juntamente com os seus respectivos volumes e imagens intermediárias"
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-tests.yml" down -v --rmi all --remove-orphans 
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-debug.yml" down -v --rmi all --remove-orphans
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-build.yml" down -v --rmi all --remove-orphans
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-runtime.yml" down -v --rmi all --remove-orphans
# docker-compose -f "docker-compose.yml" -f "docker-compose.cd-deploy-custom.yml" down -v --rmi all --remove-orphans
echo "-----------------------------------------------------------------------"