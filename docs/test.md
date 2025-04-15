# Realizando testes locais com Checkly e Playwright

## Visão geral

Este documento explica como executar testes de monitoramento localmente antes de implantá-los através do Terraform na plataforma Checkly. Testes locais são essenciais para garantir que seus monitores funcionem corretamente e para ajustar parâmetros como timeouts antes da implementação em produção.

## Pré-requisitos

Antes de iniciar, você precisará ter instalado:

- Node.js (versão 14 ou superior)
- npm (geralmente vem com Node.js)
- Git (opcional, para controle de versão)

## Configuração do ambiente de teste local

### 1. Instalação das dependências

Para configurar o ambiente de testes, execute os seguintes comandos:

```bash
# Navegue até o diretório do projeto
cd terraform-checkly-check

# Instale as dependências e configure o ambiente
npm run setup
```

Este comando instala todas as dependências necessárias, incluindo:
- Checkly CLI
- Playwright
- Navegador Chromium para testes

### 2. Configuração de variáveis de ambiente

Exporte as variáveis de ambiente necessárias para autenticação com a API do Checkly:
```bash
# Crie um arquivo .env na raiz do projeto
export CHECKLY_API_KEY=seu_api_key_aqui
export CHECKLY_ACCOUNT_ID=seu_account_id_aqui
export PLAYWRIGHT_TIMEOUT=90000

# Configuração para o Terraform
export TF_VAR_checkly_api_key=seu_api_key_aqui
export TF_VAR_checkly_account_id=seu_account_id_aqui
```


## Executando testes localmente

### Teste básico com Playwright

Para executar o teste diretamente com Playwright:

```bash
npm run test:local
```

Este comando executa o arquivo de especificação https-nataliagranato-xyz.spec.ts usando o Playwright diretamente, permitindo testar a lógica do script sem interagir com a API do Checkly.

### Teste com interface gráfica (modo debug)

Para depurar visualmente os testes:

```bash
npm run test:ui
```

Este comando abre uma interface gráfica que permite:
- Executar testes passo a passo
- Visualizar capturas de tela em cada etapa
- Inspecionar o DOM e os logs do console
- Identificar facilmente onde os testes falham

### Teste com a CLI do Checkly

Para testar a integração completa com a plataforma Checkly:

```bash
npm run test
```

Este comando valida se o arquivo de definição do check (`https-nataliagranato-xyz.check.ts`) está configurado corretamente e se integra adequadamente com a plataforma Checkly.

Para testes com informações detalhadas:

```bash
npm run test:debug
```

## Entendendo os resultados dos testes

### Artefatos gerados

Após a execução dos testes, diversos artefatos são gerados:

- **Screenshots**: Captura de tela do site no final do teste (`screenshot.png`)
- **Vídeos**: Gravação completa da execução do teste (disponível na pasta test-results)
- **Relatórios HTML**: Relatório detalhado do teste (disponível na pasta playwright-report)
- **Traces**: Informações detalhadas da execução para análise de problemas

### Interpretando falhas

Os testes podem falhar por diversos motivos:

1. **Timeouts**: O site demorou mais que o esperado para responder
   - Solução: Aumente os valores de timeout no arquivo playwright.config.js

2. **Elementos não encontrados**: O teste não conseguiu localizar elementos esperados no site
   - Solução: Verifique os seletores usados no arquivo de teste ou ajuste a lógica do teste

3. **Erros de rede**: Problemas de conectividade durante o teste
   - Solução: Verifique sua conexão ou adicione lógica de retry no teste

## Ajustando os testes

### Modificando timeouts

Os timeouts podem ser ajustados em vários níveis:

1. **No arquivo de teste** (`https-nataliagranato-xyz.spec.ts`):
   ```typescript
   test.setTimeout(120000); // Aumentar para 120 segundos
   ```

2. **Na configuração do Playwright** (`playwright.config.js`):
   ```javascript
   timeout: 120000, // Timeout global
   expect: {
     timeout: 45000, // Timeout das asserções
   },
   ```

3. **No arquivo de definição do check** (`https-nataliagranato-xyz.check.ts`):
   ```typescript
   retryStrategy: RetryStrategyBuilder.linearStrategy({
     baseBackoffSeconds: 180, // Aumentar intervalo entre tentativas
     maxRetries: 4,          // Aumentar número de tentativas
   }),
   ```

4. **Na configuração Terraform** (`main.tf`):
   ```terraform
   degraded_response_time = 45000  // Aumentar para 45 segundos
   max_response_time      = 90000  // Aumentar para 90 segundos
   ```

### Adicionando debug logs

Para melhor diagnóstico, adicione logs no arquivo de teste:

```typescript
console.log('Iniciando navegação para o site...');
await page.goto('https://nataliagranato.xyz', { timeout: 60000 });
console.log('Navegação concluída, URL atual:', page.url());
```

## Implantação após testes bem-sucedidos

Após validar que seus testes funcionam corretamente no ambiente local, você pode prosseguir com a implantação usando Terraform:

```bash
terraform init
terraform plan
terraform apply
```

## Resolução de problemas comuns

### Erro: "No such file or directory"

**Problema**: O arquivo de teste não foi encontrado.
**Solução**: Verifique se os caminhos dos arquivos estão corretos e se todos os arquivos necessários foram criados.

### Erro: "Navigation timeout of X ms exceeded"

**Problema**: O site demorou mais que o esperado para carregar.
**Solução**: Aumente os timeouts de navegação e considere usar `waitUntil: 'networkidle'` nas opções de navegação.

### Erro: "Element not found"

**Problema**: O teste não conseguiu encontrar um elemento na página.
**Solução**: Verifique se o seletor está correto ou use um seletor mais genérico. Considere também aumentar o timeout da asserção.

### Erro: "API key not found" ou "Account ID not found"

**Problema**: As credenciais da API Checkly não estão configuradas corretamente.
**Solução**: Verifique o arquivo `.env` e certifique-se de que as variáveis de ambiente estão sendo carregadas corretamente.

## Conclusão

Testes locais são uma parte fundamental do fluxo de trabalho de desenvolvimento e manutenção de monitores Checkly. Eles permitem identificar e corrigir problemas antes da implantação, economizando tempo e recursos.

Utilize os diferentes métodos de teste disponíveis de acordo com suas necessidades:
- Teste local com Playwright para desenvolvimento rápido
- Interface gráfica para depuração visual
- CLI do Checkly para validação completa

Lembre-se de ajustar os timeouts e outras configurações para refletir as características reais do seu site e da rede em que ele opera.