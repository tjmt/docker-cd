# Objetivo

> Responsável pela inserção de código shell script anterior à execução do processo de Continuous Delivery (CD) do estágio desejado.

Pré requisitos:
- Configurar os nomes dos arquivos de acordo com o estágio que deverá ser processado. Exemplo: Ao criar um arquivo `cd-pre-debug.sh`, ele será executado antes do estágio *debug* ser executado.
- Possíveis estágios:
  - *release*

Exemplo:
- [cd-pre-release.sh](../cd-pre-release.sh)