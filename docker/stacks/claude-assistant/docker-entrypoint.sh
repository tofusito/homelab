#!/bin/bash
set -e

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'

echo "=== Claude Homelab Assistant ==="

# 1. Verificar token de Telegram
if [ -z "$TELEGRAM_BOT_TOKEN" ]; then
    echo -e "${RED}ERROR: TELEGRAM_BOT_TOKEN no está configurado.${NC}"
    exit 1
fi

# 2. Ajustar GID del socket de Docker para que el usuario claude pueda acceder
# Detecta el GID del socket en el host y añade claude a ese grupo
DOCKER_GID=$(stat -c '%g' /var/run/docker.sock 2>/dev/null || echo "")
if [ -n "$DOCKER_GID" ] && [ "$DOCKER_GID" != "0" ]; then
    if ! getent group "$DOCKER_GID" > /dev/null 2>&1; then
        groupadd -g "$DOCKER_GID" dockerhost
    fi
    usermod -aG "$DOCKER_GID" claude 2>/dev/null || true
fi

# 3. Asegurar que el directorio home de claude tiene los permisos correctos
chown -R claude:claude /home/claude 2>/dev/null || true

# 4. Verificar autenticación con claude.ai (ejecutando como claude)
echo "Verificando autenticación con claude.ai..."
if ! gosu claude timeout 20 claude --print "ok" > /dev/null 2>&1; then
    echo -e "${RED}ERROR: Sesión de claude.ai no válida o expirada.${NC}"
    echo ""
    echo "Ejecuta el setup inicial para autenticarte:"
    echo "  docker compose run --rm -it --entrypoint bash claude-assistant -c 'su claude -c claude'"
    echo ""
    exit 1
fi
echo -e "${GREEN}Autenticación OK${NC}"

# 5. Configurar token de Telegram (idempotente)
TELEGRAM_CONFIG_DIR="/home/claude/.claude/channels/telegram"
mkdir -p "$TELEGRAM_CONFIG_DIR"
echo "TELEGRAM_BOT_TOKEN=$TELEGRAM_BOT_TOKEN" > "$TELEGRAM_CONFIG_DIR/.env"
chown -R claude:claude "$TELEGRAM_CONFIG_DIR"
echo -e "${GREEN}Token de Telegram configurado${NC}"

# 6. Pre-configurar settings para saltar el wizard de primera vez
CLAUDE_SETTINGS="/home/claude/.claude/settings.json"
if [ ! -f "$CLAUDE_SETTINGS" ] || ! grep -q "theme" "$CLAUDE_SETTINGS" 2>/dev/null; then
    echo '{"theme":"dark","hasCompletedProjectOnboarding":true,"hasTrustDialogAccepted":true}' > "$CLAUDE_SETTINGS"
    chown claude:claude "$CLAUDE_SETTINGS"
    echo -e "${GREEN}Settings iniciales configurados${NC}"
fi

# 7. Arrancar Claude como usuario no-root con el channel de Telegram
echo ""
echo -e "${GREEN}Arrancando Claude con canal de Telegram...${NC}"
echo -e "${YELLOW}Si es la primera vez, manda un mensaje al bot y luego ejecuta:${NC}"
echo -e "${YELLOW}  docker exec -it claude-assistant claude /channel:access pair <código>${NC}"
echo -e "${YELLOW}  docker exec -it claude-assistant claude /channel:access policy allowlist${NC}"
echo ""
exec gosu claude claude \
    --channels plugin:telegram@claude-plugins-official \
    --dangerously-skip-permissions
