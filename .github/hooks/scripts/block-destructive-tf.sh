#!/usr/bin/env bash
set -euo pipefail

# Lê o payload JSON recebido via stdin do evento PreToolUse
INPUT_JSON=$(cat)

# Padrões de comandos destrutivos do Terraform
# Exemplos: terraform destroy, terraform apply -destroy, terraform state rm
DESTRUCTIVE_PATTERN='(terraform[[:space:]]+destroy|terraform[[:space:]]+apply[[:space:]]+.*-destroy|-destroy|terraform[[:space:]]+state[[:space:]]+rm)'

if echo "$INPUT_JSON" | grep -Ei "$DESTRUCTIVE_PATTERN" > /dev/null 2>&1; then
  cat <<'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "ask",
    "permissionDecisionReason": "Comando destrutivo do Terraform detectado (ex.: destroy ou remoção de estado). Confirmação explícita do usuário é obrigatória antes da execução."
  }
}
EOF
  exit 0
fi

# Se não for comando perigoso, permite a execução
cat <<'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "allow"
  }
}
EOF
exit 0
