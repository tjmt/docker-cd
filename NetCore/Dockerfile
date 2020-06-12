#---------------Estágio usado para rodar apenas em ambiente de desenvolvimento com propósito de realizar depuração de código
FROM tjmt/dotnetcore/sdk:3.0.100 as debug

ENV SOLUTION_NAME=Portais-API-DotNet-Seed.sln
ENV PROJECT_NAME=PJMT.Aurora.API

WORKDIR /src
COPY ${SOLUTION_NAME} ./

# Copia os arquivos principais do projeto
COPY src/*/*.csproj *.dcproj ./
RUN for file in $(ls *.csproj); do mkdir -p src/${file%.*}/ && mv $file src/${file%.*}/; done

# Copia os arquivos de projeto de teste
COPY test/*/*.csproj ./
RUN for file in $(ls *.csproj); do mkdir -p test/${file%.*}/ && mv $file test/${file%.*}/; done

RUN dotnet restore ${SOLUTION_NAME} -v m

COPY . .

RUN chmod +x ./entrypoint-debug.sh
ENTRYPOINT ./entrypoint-debug.sh

#---------------Estágio usado para rodar os Testes (teste unitário, teste de integração, sonarqube)
FROM debug as tests

RUN chmod +x ./entrypoint-tests.sh
ENTRYPOINT ./entrypoint-tests.sh

#---------------Estágio usado para build/publish/pack
FROM debug as build

COPY docker-compose.cd-release.yml docker-compose.env* cd.sh /app/source/

# # Se precisar utilizar arquivos de ambiente customizados, ajuste a variável abaixo com o nome desejado.
# # Exemplo: Caso o nome do arquivo seguir o padrão 'docker-compose.env-api-{ambiente}.yml', passe o valor como 'ENV_SERVICES=api-'
# ENV ENV_SERVICES=

# COPY docker-compose.env-${ENV_SERVICES}alpha.yml /app/source/docker-compose.env-alpha.yml
# COPY docker-compose.env-${ENV_SERVICES}beta.yml /app/source/docker-compose.env-beta.yml
# COPY docker-compose.env-${ENV_SERVICES}rc.yml /app/source/docker-compose.env-rc.yml
# COPY docker-compose.env-${ENV_SERVICES}stable.yml /app/source/docker-compose.env-stable.yml

RUN dotnet build ${SOLUTION_NAME} -c Release -v m
RUN dotnet publish src/${PROJECT_NAME} -c Release --no-build -o /app/www -v m

# Caso use pacote nuget, descomentar linha abaixo, e informar projeto correto
# RUN dotnet src/${PROJECT_NAME} -c Release --no-build -o /app/package -v m 

#---------------Estágio usado para runtime
FROM tjmt/dotnetcore:aspnet-3.0 as runtime

ENV PROJECT_NAME=PJMT.Aurora.API

COPY --from=build /app/www /app/www
WORKDIR /app/www

ENTRYPOINT dotnet ${PROJECT_NAME}.dll

# Utilize o espaço abaixo apenas se você precisar realizar uma publicação customizada de sua aplicação

# #---------------Estágio usada para publicação (kubernetes/nuget)
# FROM tjmt/publicador:latest as deploy

# COPY docker-compose.env* /var/release/source/
# COPY --from=build /app/www/ /var/release/www

# # Caso use pacote nuget, descomentar linha abaixo
# # COPY --from=build /app/package /var/release/packages/nuget

# FROM runtime AS final