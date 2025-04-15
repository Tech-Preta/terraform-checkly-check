# Esta configuração do Terraform define dois recursos:
# 
# 1. `checkly_check`:
#    - Representa uma verificação baseada em navegador para a URL "https://nataliagranato.xyz".
#    - Executa a cada 5 minutos de duas localizações: "sa-east-1" e "af-south-1".
#    - Inclui um arquivo de script para a lógica da verificação: "./https-nataliagranato-xyz.check.ts".
#    - Configura limites de tempo de resposta:
#      - Tempo de resposta degradado: 30.000 ms.
#      - Tempo máximo de resposta: 60.000 ms.
#    - Configurações de alerta:
#      - Tipo de escalonamento: Baseado em execução com um limite de falhas de 1 execução.
#      - Escalonamento baseado em tempo com um limite de falha de 5 minutos.
#      - Nenhum lembrete está configurado.
#    - Estratégia de repetição:
#      - Backoff linear com base de 120 segundos.
#      - Máximo de tentativas: 3.
#      - Duração máxima: 1200 segundos.
#      - As tentativas são limitadas à mesma região.
#    - Usa configurações globais de alerta.
# 
# 2. `checkly_alert_channel`:
#    - Configura um canal de alerta por e-mail.
#    - Envia alertas para "contato@nataliagranato.xyz".
#    - Envia notificações de recuperação e falha.
#    - Não envia notificações de degradação.
resource "checkly_check" "https-nataliagranato-xyz" {
  name                   = "https://www.nataliagranato.xyz"
  type                   = "BROWSER"
  frequency              = 5
  activated              = true
  muted                  = false
  should_fail            = false
  run_parallel           = true
  locations              = ["sa-east-1", "af-south-1"]
  script                 = file("./https-nataliagranato-xyz.spec.ts")
  degraded_response_time = 15000
  max_response_time      = 30000
  tags                   = []
  ssl_check_domain       = ""
  alert_settings {
    escalation_type = "RUN_BASED"
    run_based_escalation {
      failed_run_threshold = 2
    }
    time_based_escalation {
      minutes_failing_threshold = 10
    }
    reminders {
      amount   = 0
      interval = 5
    }
  }
  retry_strategy {
    type                 = "LINEAR"
    base_backoff_seconds = 120
    max_retries          = 3
    max_duration_seconds = 600
    same_region          = true
  }
  use_global_alert_settings = true
  # group_id                = ""
  # group_order             = ""
}

resource "checkly_alert_channel" "email-253278" {
  email {
    address = "contato@nataliagranato.xyz"
  }
  send_recovery = true
  send_failure  = true
  send_degraded = false
  ssl_expiry    = false
}

