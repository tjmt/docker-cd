# Objetivo

> Responsável pela inserção de código shell script anterior à execução do processo de Continuous Integration (CI) do estágio desejado.

Pré requisitos:
- Configurar os nomes dos arquivos de acordo com o estágio que deverá ser processado. Exemplo: Ao criar um arquivo `ci-pre-debug.sh`, ele será executado antes do estágio *debug* ser executado.
- Possíveis estágios:
  - *tests*
  - *debug*
  - *build*
  - *runtime*
  - *deploy*

Exemplo:
- [ci-pre-debug.sh](../ci-pre-debug.sh)
