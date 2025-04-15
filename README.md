# Documentação do Projeto de Monitoramento com Checkly e Terraform

## Visão Geral

Este projeto implementa uma solução de monitoramento para o site "https://nataliagranato.xyz" utilizando a plataforma Checkly, gerenciada como código através do Terraform. A configuração estabelece verificações automatizadas de disponibilidade e desempenho do site, com alertas configurados para notificar quando problemas são detectados.

## Arquitetura da Solução

A solução é composta por dois recursos principais:

1. **Verificação de Monitoramento (Browser Check)**: Testa automaticamente a disponibilidade e o desempenho do site.
2. **Canal de Alerta**: Envia notificações por e-mail quando problemas são detectados.

## Componentes da Verificação

### Verificação de Navegador (Browser Check)

- **URL monitorada**: https://nataliagranato.xyz
- **Frequência**: A cada 5 minutos
- **Localidades**: América do Sul (sa-east-1) e África (af-south-1)
- **Limites de desempenho**:
  - Resposta degradada: > 15.000 ms (15 segundos)
  - Resposta máxima: > 30.000 ms (30 segundos)

### Estratégia de Notificação

- **Tipo de escalonamento**: Baseado em execução
- **Limite de falhas**: 1 execução falha
- **Escalonamento baseado em tempo**: Após 5 minutos de falhas
- **Sem lembretes** configurados (amount = 0)

### Estratégia de Retry

- **Tipo**: Linear
- **Intervalo base**: 60 segundos
- **Máximo de tentativas**: 2
- **Duração máxima**: 600 segundos (10 minutos)
- **Mesma região**: Sim (retentativas ocorrem na mesma região da falha original)

### Canal de Alerta

- **Tipo**: E-mail
- **Endereço**: contato@nataliagranato.xyz
- **Notificações**:
  - Recuperação: Sim
  - Falha: Sim
  - Degradação: Não

## Implementação

O projeto utiliza a abordagem de Infraestrutura como Código (IaC) com Terraform, permitindo que toda a configuração de monitoramento seja versionada, reproduzível e facilmente modificável.

### Script de Verificação

O comportamento exato da verificação é definido em um script TypeScript externo (`https-nataliagranato-xyz.check.ts`), que define as ações a serem realizadas durante o teste de navegador. Este script interage com o site para verificar sua disponibilidade e funcionamento correto.

## Requisitos e Dependências

### Requisitos de Software

- Terraform (compatível com o provider Checkly ~> 1.0)
- Provider Checkly (versão atual: 1.11.0)

### Variáveis de Entrada

| Nome | Descrição | Tipo | Obrigatório |
|------|-----------|------|:--------:|
| `checkly_account_id` | ID da conta Checkly | string | sim |
| `checkly_api_key` | Chave de API Checkly | string | sim |

## Como Usar

### Configuração Inicial

1. Clone este repositório
2. Configure as variáveis necessárias:
   ```bash
   export TF_VAR_checkly_account_id="seu_account_id"
   export TF_VAR_checkly_api_key="sua_api_key"
   ```

### Implantação

```bash
# Inicializar o Terraform
terraform init

# Validar a configuração
terraform validate

# Visualizar o plano de execução
terraform plan

# Aplicar as mudanças
terraform apply
```

### Verificação do Status

Para verificar o status das verificações configuradas, acesse o [dashboard da Checkly](https://app.checklyhq.com/) com suas credenciais.

## Benefícios da Solução

- **Monitoramento proativo**: Detecta problemas antes que afetem os usuários
- **Cobertura geográfica**: Testa o site a partir de diferentes regiões do mundo
- **Alertas automáticos**: Notifica imediatamente quando problemas são detectados
- **Gerenciado como código**: Facilita a manutenção e evolução da configuração
- **Estratégia de retentativas**: Reduz falsos positivos com verificações adicionais

Esta solução oferece monitoramento robusto e confiável para garantir a disponibilidade e o desempenho do site "nataliagranato.xyz".


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_checkly"></a> [checkly](#requirement\_checkly) | ~> 1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_checkly"></a> [checkly](#provider\_checkly) | 1.11.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [checkly_alert_channel.email_ac](https://registry.terraform.io/providers/checkly/checkly/latest/docs/resources/alert_channel) | resource |
| [checkly_check.https-nataliagranato-xyz](https://registry.terraform.io/providers/checkly/checkly/latest/docs/resources/check) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_checkly_account_id"></a> [checkly\_account\_id](#input\_checkly\_account\_id) | n/a | `any` | n/a | yes |
| <a name="input_checkly_api_key"></a> [checkly\_api\_key](#input\_checkly\_api\_key) | n/a | `any` | n/a | yes |

## Outputs

No outputs.
