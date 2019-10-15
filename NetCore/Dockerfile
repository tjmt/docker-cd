#---------------Imagem usada para Instalação de ferramentas/bibliotecas adicionais
FROM tjmt/dotnetcore/sdk:2.2.202 as base


#---------------Estágio usada para rodar o CI (restore, teste, sonarqube)
FROM base as ci
ARG CONFIGURATION=Release
ENV CONFIGURATION=$CONFIGURATION
ENV SOLUTION_NAME=Portais-API-DotNet-Seed.sln


WORKDIR /src
#====================================================================#
# Se utilizar o copy informando o path dos projetos, será utilizado cache do RESTORE, porém para cada projeto criado, tem que ser adicionado no copy
# Um caso ou outro devido issue https://github.com/moby/moby/issues/15858
COPY ["docker-compose.dcproj", "docker-compose.dcproj"]
COPY ["Portais-API-DotNet-Seed.sln", "Portais-API-DotNet-Seed.sln"]
COPY ["src/PJMT.Aurora.API/PJMT.Aurora.API.csproj", "src/PJMT.Aurora.API/"]
COPY ["src/PJMT.Aurora.Infra.Application/PJMT.Aurora.Infra.Application.csproj", "src/PJMT.Aurora.Infra.Application/"]
COPY ["src/PJMT.Aurora.Infra.CrossCutting.Identity/PJMT.Aurora.Infra.CrossCutting.Identity.csproj", "src/PJMT.Aurora.Infra.CrossCutting.Identity/"]
COPY ["src/PJMT.Aurora.Domain/PJMT.Aurora.Domain.csproj", "src/PJMT.Aurora.Domain/"]
COPY ["src/PJMT.Aurora.Infra.Data.EF.Repository/PJMT.Aurora.Infra.Data.EF.Repository.csproj", "src/PJMT.Aurora.Infra.Data.EF.Repository/"]
COPY ["src/PJMT.Aurora.Infra.CrossCutting.IoC/PJMT.Aurora.Infra.CrossCutting.IoC.csproj", "src/PJMT.Aurora.Infra.CrossCutting.IoC/"]
COPY ["src/PJMT.Aurora.Infra.Data.Dapper/PJMT.Aurora.Infra.Data.Dapper.csproj", "src/PJMT.Aurora.Infra.Data.Dapper/"]
COPY ["src/PJMT.Aurora.Infra.Data.MongoDB/PJMT.Aurora.Infra.Data.MongoDB.csproj", "src/PJMT.Aurora.Infra.Data.MongoDB/"]
COPY ["test/PJMT.Aurora.Test/PJMT.Aurora.Test.csproj", "test/PJMT.Aurora.Test/"]
RUN dotnet restore ${SOLUTION_NAME} -v m
COPY . .
ENTRYPOINT /entrypoint/entrypoint.sh
#----------------------------------------------------------------------------------------------#


#---------------Estágio usada para build/publish/pack
FROM ci as publish
RUN dotnet build ${SOLUTION_NAME} -c ${CONFIGURATION} -v m
RUN dotnet publish src/PJMT.Aurora.API -c ${CONFIGURATION} --no-build -o /app/www -v m

#Caso use pacote nuget, descomentar linha abaixo, e informar projeto correto
#RUN dotnet src/PJMT.Aurora.API -c ${CONFIGURATION} --no-build -o /app/package -v m
 

#---------------Estágio usada para runtime
FROM tjmt/dotnetcore:aspnet-2.2 as runtime
COPY --from=publish /app/www /app/www
WORKDIR /app/www
ENTRYPOINT dotnet PJMT.Aurora.API.dll


#---------------Estágio usada para publicação (kubernetes/nuget)
FROM tjmt/publicador:latest as release
ARG VERSION
ARG BRANCH
ENV VERSION=${VERSION}
ENV BRANCH=${BRANCH}

COPY . /var/release/source
COPY --from=publish /app/www/ /var/release/www
#Caso use pacote nuget, descomentar linha abaixo
#COPY --from=publish /app/package /var/release/packages/nuget


FROM runtime AS final