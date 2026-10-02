---
description: "Diretrizes e padrões para criação, edição e manutenção de arquivos de configuração Terraform (.tf)."
applyTo: "**/*.tf"
---

# Diretrizes para Código Terraform (.tf)

Ao criar, editar ou refatorar arquivos de configuração Terraform (`.tf`), siga rigorosamente os padrões abaixo:

## 1. Formatação e Convenções de Nomenclatura
- Mantenha o código sempre formatado de acordo com o padrão canônico (`terraform fmt`).
- Use `snake_case` para nomes de recursos, data sources, variáveis e saídas (ex.: `checkly_check.site_monitor`).
- Não repita o tipo de recurso no nome (prefira `resource "checkly_check" "site"` em vez de `resource "checkly_check" "check_site"`).

## 2. Declaração de Variáveis e Saídas
- Toda variável de entrada em `variables.tf` deve conter:
  - `type` explícito (`string`, `number`, `bool`, `list`, `map`, `object`).
  - `description` clara e explicativa.
  - `default` quando aplicável, ou obrigatoriedade explícita.
  - `sensitive = true` caso contenha senhas, chaves de API, certificados ou tokens.
- Toda saída em `outputs.tf` deve conter `description` e `value`.

## 3. Segurança e Gestão de Segredos
- **Nunca** inclua credenciais, senhas, tokens ou dados sensíveis em texto puro em arquivos `.tf`.
- Utilize variáveis de ambiente (ex.: `TF_VAR_checkly_api_key`) ou ferramentas de segredos para credenciais de providers.

## 4. Estrutura Modular
- Separe as configurações por responsabilidade:
  - `versions.tf`: `terraform` block com `required_version` e `required_providers`.
  - `main.tf`: Declaração dos recursos e datasources.
  - `variables.tf`: Variáveis de entrada.
  - `outputs.tf`: Valores exportados após o apply.

## 5. Prevenção de Falhas e Validação
- Sempre verifique a sintaxe e consistência com `terraform validate` após editar blocos de recursos.
- Declare dependências implícitas por referência de atributos entre recursos sempre que possível (evitando `depends_on` desnecessário).
