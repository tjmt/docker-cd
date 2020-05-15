#!/bin/bash

echo "Iniciando entrypoint - DEBUG"
dotnet run -c Debug --no-launch-profile -p ./src/${PROJECT_NAME}