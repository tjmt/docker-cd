#!/bin/bash

echo "Iniciando entrypoint - DEBUG"
cd ./src/${PROJECT_NAME} && dotnet run -c Debug --no-launch-profile