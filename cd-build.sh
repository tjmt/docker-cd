clear
rm -rf ./docker-extract/
mkdir ./docker-extract/

#Essas variaveis precisam estar na release também
export DOCKER_REGISTRY=""
export VERSION=$(date '+%Y%m%d')-1
export BRANCH="develop"


echo "-----------------------------------------------------------------------"
echo "Iniciando cd-build.sh."
echo "ImageName: ${DOCKER_REGISTRY}/app:${BRANCH}.${VERSION}"
echo "-----------------------------------------------------------------------"


#Para remover todas as images intermediarias, volume, e outras dependencias, rodar os comandos abaixo
#echo ""
#echo "-----------------------------------------------------------------------"
# docker-compose -f "docker-compose.yml" -f "docker-compose.cd-tests.yml" down -v --rmi all --remove-orphans
# docker-compose -f "docker-compose.yml" -f "docker-compose.cd-build.yml" down -v --rmi all --remove-orphans
# docker-compose -f "docker-compose.yml" -f "docker-compose.cd-runtime.yml" down -v --rmi all --remove-orphans
#echo "-----------------------------------------------------------------------"



#Variaveis locais, utilizado para copiar os arquivos do container
ARTIFACT_STAGING_DIRECTORY="./docker-extract"
DOCKERCOMPOSE_BUILD_VOLUME_NAME="app-extract-testresults"
DOCKERCOMPOSE_BUILD_CONTAINER_NAME="container-testResults"
DOCKERCOMPOSE_BUILD_TEST_RESULT_PATH="/TestResults"

#Build
export SONARQUBE_URL="http://localhost:9000"
export SONARQUBE_LOGIN=""
export RUN_TEST="true"
export RUN_PROJECT="false"
export RUN_SONARQUBE="true"
export CONFIGURATION="Debug"


echo "-----------------------------------------------------------------------"
echo "Run docker-compose.cd-tests.yml"
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-tests.yml" up --build --abort-on-container-exit && \
#docker-compose -f "docker-compose.yml" -f "docker-compose.cd-tests.yml" push && \
echo "Extraindo os resultados dos testes" && \
docker create --name $DOCKERCOMPOSE_BUILD_CONTAINER_NAME -v $DOCKERCOMPOSE_BUILD_VOLUME_NAME:$DOCKERCOMPOSE_BUILD_TEST_RESULT_PATH busybox && \
docker cp $DOCKERCOMPOSE_BUILD_CONTAINER_NAME:$DOCKERCOMPOSE_BUILD_TEST_RESULT_PATH $ARTIFACT_STAGING_DIRECTORY/TestResults && \
docker rm $DOCKERCOMPOSE_BUILD_CONTAINER_NAME
echo "-----------------------------------------------------------------------"



echo ""
echo "-----------------------------------------------------------------------"
echo "Run docker-compose.cd-build.yml"
export DOCKERCOMPOSE_PUBLISH_VOLUME_NAME="app-extract-publish"
export DOCKERCOMPOSE_PUBLISH_CONTAINER_NAME="container-publish"
export DOCKERCOMPOSE_PUBLISH_APP_PATH="/var/release/"

docker-compose -f "docker-compose.yml" -f "docker-compose.cd-build.yml" up --build --abort-on-container-exit && \
#docker-compose -f "docker-compose.yml" -f "docker-compose.cd-build.yml" push && \
echo "Extraindo o artefatos" && \
docker create --name $DOCKERCOMPOSE_PUBLISH_CONTAINER_NAME -v $DOCKERCOMPOSE_PUBLISH_VOLUME_NAME:$DOCKERCOMPOSE_PUBLISH_APP_PATH busybox && \
docker cp $DOCKERCOMPOSE_PUBLISH_CONTAINER_NAME:$DOCKERCOMPOSE_PUBLISH_APP_PATH $ARTIFACT_STAGING_DIRECTORY/artefatos && \
docker rm $DOCKERCOMPOSE_PUBLISH_CONTAINER_NAME
echo "-----------------------------------------------------------------------"


echo ""
echo "-----------------------------------------------------------------------"
echo "Run docker-compose.cd-runtime.yml"
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-runtime.yml" build
#docker-compose -f "docker-compose.yml" -f "docker-compose.cd-runtime.yml" push
echo "-----------------------------------------------------------------------"
