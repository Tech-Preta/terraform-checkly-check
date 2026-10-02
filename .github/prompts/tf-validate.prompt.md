---
name: "Terraform Validate & Format Check"
description: "Valida a sintaxe e verifica a formatação canônica de todos os arquivos Terraform no repositório."
tools: [execute]
---

Execute a validação e verificação de integridade dos arquivos Terraform no repositório:

1. **Checagem de Formatação**:
   - Execute `terraform fmt -check` para identificar arquivos fora da formatação canônica.
   - Caso haja divergências, liste os arquivos que precisam ser formatados e sugira a execução de `terraform fmt`.

2. **Validação Sintática**:
   - Execute `terraform validate` para checar sintaxe, atributos e tipos de recursos declarados.
   - Se ocorrer erro de inicialização de providers, execute `terraform init -backend=false` antes da validação.

3. **Relatório**:
   - Apresente um resumo claro do status de formatação e integridade da configuração.
