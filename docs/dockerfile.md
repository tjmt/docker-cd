# Dockerfile
**Referência:** [Dockerfile](https://docs.docker.com/engine/reference/builder/)

**Objetivo:** Criar o arquivo Dockerfile, o qual é responsável por compilar, testar, análisar, publicar e executar o projeto (permitindo debug).
 

---
## Padrões

* Deve possíbilitar o Debug pela principal IDE da tecnologia (JAVA=Eclipse, .NET=Visual Studio, NODE=VSCode) mais o VSCode
* Utilizar as melhores práticas para uso de cache:
  - [dockerfile_best-practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
  - [best-practices-for-working-with-dockerfile](https://medium.com/@nagarwal/best-practices-for-working-with-dockerfiles-fb2d22b78186)
* Utilizar as melhores práticas para uso de Multistage
  - [Referência](https://docs.docker.com/develop/develop-images/multistage-build/)
* Deve possuir os seguintes estágios:
  * <details>
      <summary>Multistage</summary>

      - **base:** 
        - Estágio para instalação de ferramentas/bibliotecas adicionais, que não estão na imagem base, necessárias para compilação/execução dos testes do projeto.
      - **ci:**
        - Copiar somente os arquivos necessários para restore de pacotes.
        - Restaurar
        - entrypoint => Continuous Integration
          - Análise de código pelo sonarqube
          - Rodar testes unitários/integração
          - Gerar artefatos com os resultados dos teste/code coverage
      - **publish:** 
        - Estágio para geração dos arquivos finais (runtime/pacotes)
      - **runtime**
        - Estágio de runtime da aplicação
      - **release:** 
        - Estágio de deploy dos arquivos.
          - Pacotes nuget/npm/maven no registry
          - Kubernetes
      - **final:** 
        - Estágio final (Pode ser o `runtime`)
    </details>
* Deve salvar os resultados dos testes nos caminhos pré definidos (Estágio **CI**)
  * <details>
      <summary>TestResults</summary>
    
      - Resultado do teste (unitário/integração)
        - vstest: `/TestResults/result/vsTest/`
        - junit:  `/TestResults/result/junit/`
        - nunit:  `/TestResults/result/nunit/`
        - xunit:  `/TestResults/result/xunit/`
        - sonarqube ([generic test](https://docs.sonarqube.org/latest/analysis/generic-test/)): `/TestResults/result/sonarqube/`
      - Cobertura de código
        - cobertura: `/TestResults/codecoverage/coverage.cobertura.xml`
        - opencover:  `/TestResults/codecoverage/coverage.opencover.xml`
        - lcov: `/TestResults/codecoverage/lcov.info`
        - html: `/TestResults/codecoverage/Report/`    
    </details>
* Deve salvar os arquivos finais nos caminhos pré definidos. (Estágio **release**)
  * <details>
      <summary>Artefatos</summary>

      - packages:
        - npm:   `/var/release/packages/npm/`
        - nuget: `/var/release/packages/nuget/`
        - maven: `/var/release/packages/maven/`
      - source: `/var/release/source/`
      - www: `/var/release/www/`
    </details>


## Exemplos

* [.Net](.././NetCore/Dockerfile)
* [Java](.././Java/Dockerfile)
* [angular](.././Angular/Dockerfile)