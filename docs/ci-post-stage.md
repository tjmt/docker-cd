# Objetivo

> Responsável pela inserção de código shell script posterior à execução do processo de Continuous Integration (CI) do estágio desejado.

Pré requisitos:
- Configurar os nomes dos arquivos de acordo com o estágio que deverá ser processado. Exemplo: Ao criar um arquivo `ci-post-debug.sh`, ele será executado depois do estágio *debug* ser executado.
- Possíveis estágios:
  - *tests*
  - *debug*
  - *build*
  - *runtime*
  - *deploy*

Exemplo:
- [ci-post-debug.sh](../ci-post-debug.sh)