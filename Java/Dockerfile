# Imagem usada para a fase de construção (restaurar, compilar, testar)
FROM maven:3.5.4-jdk-8 AS build
WORKDIR /src
EXPOSE 80 443

# Argumentos necessários para a compilação do projeto


# Instalar e configurar ferramentas


# Restaurar os pacotes
COPY pom.xml .
RUN mvn package -Dmaven.test.skip=true -Dspring-boot.repackage.skip=true

# Compilar o projeto
COPY . .
RUN mvn package -Dmaven.test.skip.exec=$SKIP_TEST
RUN cp target/*.jar ./app.jar

# Executar os testes
ENTRYPOINT mvn test

# Imagem usada para a fase de execução (executar)
FROM openjdk:8-jre AS final
WORKDIR /app
COPY --from=build /src/app.jar /app
ENTRYPOINT exec java $JAVA_OPTS -jar app.jar
EXPOSE 80 443