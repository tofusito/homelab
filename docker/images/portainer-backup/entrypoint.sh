#!/bin/bash
set -e

# Configuración
BASE_URL="${PORTAINER_URL:-http://portainer:9000}/api"
BACKUP_DIR="/backups"

# Función de backup (reutilizamos el script principal o lógica inline, mejor llamar al script principal)
check_initial_backup() {
    echo "[INIT] Verificando si existen backups previos..."
    count=$(find "$BACKUP_DIR" -name "portainer_backup_*.tar.gz" | wc -l)
    
    if [ "$count" -eq 0 ]; then
        echo "[INIT] No se encontraron backups. Ejecutando backup inicial..."
        /usr/local/bin/backup.sh
    else
        echo "[INIT] Se encontraron $count backups existentes. Saltando backup inicial."
    fi
}

# Ejecutar verificación inicial
check_initial_backup

# Iniciar cron en primer plano
echo "[INIT] Iniciando demonio Cron..."
exec crond -f -d 8

