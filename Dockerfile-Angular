#---------------Imagem usada para Instalação de ferramentas/bibliotecas adicionais
FROM tjmt/angular:node-10 as base


#---------------Estágio usada para rodar o CI, teste, sonarqube
FROM base as ci
WORKDIR /app
COPY package.json package-lock.json .npmrc ./
RUN npm ci
COPY . ./
EXPOSE 4200


#---------------Estágio usada para build/publish/pack
FROM ci as publish
WORKDIR /app
RUN npm run build -- --aot=true --build-optimizer=true --optimization=true --prod --configuration=production --base-href=/ --output-path=www
RUN npm pack
RUN mkdir -p /app/package && mv *.tgz /app/package

#---------------Estágio usada para runtime
FROM tjmt/angular:nginx-1.17.4 AS runtime
COPY --from=publish /app/www/ /usr/share/nginx/html/


#---------------Estágio usada para publicação (kubernetes/npm)
FROM tjmt/publicador:latest as release
ARG VERSION
ARG BRANCH
ENV VERSION=${VERSION}
ENV BRANCH=${BRANCH}

COPY . /var/release/source
COPY --from=publish /app/www/ /var/release/www
COPY --from=publish /app/package /var/release/packages/npm


FROM runtime AS final
