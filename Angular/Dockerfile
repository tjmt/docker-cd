#---------------Estágio usado para rodar apenas em ambiente de desenvolvimento com propósito de realizar depuração de código
FROM tjmt/angular:node-10 as debug

WORKDIR /source
COPY package.json package-lock.json .npmrc ./
RUN npm ci
COPY docker-compose.cd-deploy.yml docker-compose.env* /app/source/
COPY . .

RUN chmod +x ./entrypoint-debug.sh
ENTRYPOINT ./entrypoint-debug.sh

#---------------Estágio usado para rodar os Testes (teste unitário, teste de integração, sonarqube)
FROM debug as tests

RUN chmod +x ./entrypoint-tests.sh
ENTRYPOINT ./entrypoint-tests.sh

#---------------Estágio usada para build/publish/pack
FROM debug as build

RUN npm run build -- --aot=true --build-optimizer=true --optimization=true --prod --configuration=production --base-href=/ --output-path=www

# Caso use pacote npm, descomentar abaixo
# RUN npm pack
# RUN mkdir -p /app/package && mv *.tgz /app/package

#---------------Estágio usado para runtime
FROM tjmt/angular:nginx-1.17.5 AS runtime

COPY --from=build /source/entrypoint.sh /usr/share/nginx/html
COPY --from=build /app/www /usr/share/nginx/html

WORKDIR /usr/share/nginx/html
RUN chmod +x ./entrypoint.sh
ENTRYPOINT ./entrypoint.sh

# Utilize o espaço abaixo apenas se você precisar realizar uma publicação customizada de sua aplicação

# #---------------Estágio usada para publicação (kubernetes/nuget)
# FROM tjmt/publicador:latest as deploy

# COPY docker-compose.env* /var/release/source/
# COPY --from=build /app/www/ /var/release/www

# # Caso use pacote npm, descomentar linha abaixo
# # COPY --from=build /app/package /var/release/packages/npm

# FROM runtime AS final