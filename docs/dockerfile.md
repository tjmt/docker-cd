# Dockerfile
**Referência:** [Dockerfile](https://docs.docker.com/engine/reference/builder/)

**Objetivo:** Criar o arquivo Dockerfile, o qual é responsável por compilar, testar, análisar, publicar e executar o projeto (permitindo debug).
 

---
## Padrões

* Deve possíbilitar o Debug pela principal IDE da tecnologia (JAVA=Eclipse, .NET=Visual Studio, NODE=VSCode) mais o VSCode
* Deve possibilitar informar o Proxy

<details>
  <summary>TestResults</summary>

Deve expor os resultados dos testes no caminho definido.

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


<details>
  <summary>Artefatos</summary>

Deve expor os arquivos do resultado da compilação no caminho definido pela variável.
  - packages:
    - npm:   `/var/release/packages/npm/`
    - nuget: `/var/release/packages/nuget/`
    - maven: `/var/release/packages/maven/`
  - source: `/var/release/source/`
  - www: `/var/release/www/`

</details>


<details>
  <summary>Registry (bibliotecas)</summary>

   Variaveis de ambiente
        
  - NPM
    - NPM_REGISTRY
    - NPM_USER
    - NPM_PASS
    - NPM_EMAIL
  - NUGET
    - NUGET_REGISTRY
    - NUGET_USER
    - NUGET_PASS
  - MAVEN
    - MAVEN_REGISTRY
    - MAVEN_USER
    - MAVEN_PASS

</details>

<details>
  <summary>Cache</summary>

  Utilizar das boas práticas para uso de cache
- [dockerfile_best-practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [best-practices-for-working-with-dockerfile](https://medium.com/@nagarwal/best-practices-for-working-with-dockerfiles-fb2d22b78186)
</details>

<details>
  <summary>Multistage</summary>

  1. [Referência](https://docs.docker.com/develop/develop-images/multistage-build/)
  1. Todas as linguagens possuem as seguintes etapas em um Dockerfile. Estas são:

  - **base:** 
    - Estágio de instalação das ferramentas necessárias para compilação do projeto
  - **ci:**
    - Restaurar
    - Compilar
    - Continuous Integration
      - Rodar testes unitários/integração, 
      - Análise de código pelo sonarqube
      - Possibilitar entrypoint para criação de um ambiente para os testes.
  - **publish:** 
    - Estágio para geração dos arquivos finais (runtime/pacotes)
  - **runtime**
    - Estágio de runtime da aplicação
  - **release:** 
    - Estágio de deploy dos arquivos.
      - Pacotes nuget/npm/maven no registry
      - Kubernetes
  - **final:** 
    - Estágio final (POde ser o `runtime`)
</details>



## Exemplos

* [.Net](.././NetCore/Dockerfile)
* [Java](.././Java/Dockerfile)
* [angular](.././Angular/Dockerfile)