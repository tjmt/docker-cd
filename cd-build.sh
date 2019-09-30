clear
rm -rf ./docker-extract/
mkdir ./docker-extract/

#Essas variaveis precisam estar na release também
export DOCKER_REGISTRY=nexusdocker.tjmt.jus.br
export VERSION=20190927-1
export BRANCH=feature-1


echo "-----------------------------------------------------------------------"
echo "Iniciando cd-build.sh."
echo "ImageName: ${DOCKER_REGISTRY}/dsa/dotnetcoreseed.tjmt.jus.br:${BRANCH}.${VERSION}"
echo "-----------------------------------------------------------------------"


#Para remover todas as images intermediarias, volume, e outras dependencias, rodar os comandos abaixo
#echo ""
#echo "-----------------------------------------------------------------------"
# docker-compose -f "docker-compose.yml" -f "docker-compose.cd-ci.yml" down -v --rmi all --remove-orphans
# docker-compose -f "docker-compose.yml" -f "docker-compose.cd-publish.yml" down -v --rmi all --remove-orphans
# docker-compose -f "docker-compose.yml" -f "docker-compose.cd-final.yml" down -v --rmi all --remove-orphans
#echo "-----------------------------------------------------------------------"



#Variaveis locais, utilizado para copiar os arquivos do container
ARTIFACT_STAGING_DIRECTORY="./docker-extract"
DOCKERCOMPOSE_BUILD_VOLUME_NAME="dotnetcoreseed-extract-testresults"
DOCKERCOMPOSE_BUILD_CONTAINER_NAME="container-testResults"
DOCKERCOMPOSE_BUILD_TEST_RESULT_PATH="/TestResults"

#Build
export SONARQUBE_URL="http://sonarqube.tjmt.jus.br"
export SONARQUBE_LOGIN="c29b8801c173a4d9605a5eba61a069272b80dc7c"
export RUN_TEST="true"
export RUN_PROJECT="false"
export RUN_SONARQUBE="true"
export CONFIGURATION="Debug"


echo "-----------------------------------------------------------------------"
echo "Run docker-compose.cd-ci.yml"
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-ci.yml" up --build --abort-on-container-exit && \
#docker-compose -f "docker-compose.yml" -f "docker-compose.cd-ci.yml" push && \
echo "Extraindo os resultados dos testes" && \
docker create --name $DOCKERCOMPOSE_BUILD_CONTAINER_NAME -v $DOCKERCOMPOSE_BUILD_VOLUME_NAME:$DOCKERCOMPOSE_BUILD_TEST_RESULT_PATH busybox && \
docker cp $DOCKERCOMPOSE_BUILD_CONTAINER_NAME:$DOCKERCOMPOSE_BUILD_TEST_RESULT_PATH $ARTIFACT_STAGING_DIRECTORY/TestResults && \
docker rm $DOCKERCOMPOSE_BUILD_CONTAINER_NAME
echo "-----------------------------------------------------------------------"



echo ""
echo "-----------------------------------------------------------------------"
echo "Run docker-compose.cd-publish.yml"
export DOCKERCOMPOSE_PUBLISH_VOLUME_NAME="dotnetcoreseed-extract-publish"
export DOCKERCOMPOSE_PUBLISH_CONTAINER_NAME="container-publish"
export DOCKERCOMPOSE_PUBLISH_APP_PATH="/var/release/"

docker-compose -f "docker-compose.yml" -f "docker-compose.cd-publish.yml" up --build --abort-on-container-exit && \
#docker-compose -f "docker-compose.yml" -f "docker-compose.cd-publish.yml" push && \
echo "Extraindo o artefatos" && \
docker create --name $DOCKERCOMPOSE_PUBLISH_CONTAINER_NAME -v $DOCKERCOMPOSE_PUBLISH_VOLUME_NAME:$DOCKERCOMPOSE_PUBLISH_APP_PATH busybox && \
docker cp $DOCKERCOMPOSE_PUBLISH_CONTAINER_NAME:$DOCKERCOMPOSE_PUBLISH_APP_PATH $ARTIFACT_STAGING_DIRECTORY/artefatos && \
docker rm $DOCKERCOMPOSE_PUBLISH_CONTAINER_NAME
echo "-----------------------------------------------------------------------"


echo ""
echo "-----------------------------------------------------------------------"
echo "Run docker-compose.cd-final.yml"
docker-compose -f "docker-compose.yml" -f "docker-compose.cd-final.yml" build
#docker-compose -f "docker-compose.yml" -f "docker-compose.cd-final.yml" push
echo "-----------------------------------------------------------------------"