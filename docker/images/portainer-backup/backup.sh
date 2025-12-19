#!/bin/bash
set -e

# Configuración
# Limpiar la URL para evitar duplicar /api o /
CLEAN_URL="${PORTAINER_URL%/api}"
CLEAN_URL="${CLEAN_URL%/}"
BASE_URL="${CLEAN_URL}/api"

BACKUP_DIR="/backups"
DATE=$(date +%F)
FILENAME="portainer_backup_${DATE}.tar.gz"

echo "[INFO] Iniciando backup de Portainer a las $(date)..."
echo "[INFO] URL API: $BASE_URL"
echo "[INFO] Usuario: $PORTAINER_USER"

# 1. Obtener Token de autenticación
# Generar payload JSON seguro usando jq para evitar errores con caracteres especiales en la contraseña
PAYLOAD=$(jq -n --arg u "$PORTAINER_USER" --arg p "$PORTAINER_PASS" '{username: $u, password: $p}')

# Capturamos respuesta completa y código de estado
RESPONSE_BODY=$(mktemp)
HTTP_CODE=$(curl -s -o "$RESPONSE_BODY" -w "%{http_code}" -X POST -H "Content-Type: application/json" \
  -d "$PAYLOAD" \
  "$BASE_URL/auth")

if [ "$HTTP_CODE" -ne 200 ]; then
    echo "[ERROR] Fallo al autenticar. Código HTTP: $HTTP_CODE"
    echo "[DEBUG] Respuesta del servidor:"
    cat "$RESPONSE_BODY"
    rm -f "$RESPONSE_BODY"
    exit 1
fi

AUTH_TOKEN=$(cat "$RESPONSE_BODY" | jq -r .jwt)
rm -f "$RESPONSE_BODY"

if [ "$AUTH_TOKEN" == "null" ] || [ -z "$AUTH_TOKEN" ]; then
    echo "[ERROR] No se pudo extraer el token JWT. Respuesta no válida."
    exit 1
fi

    # 2. Realizar Backup
    # Enviamos un objeto JSON vacío o con password vacío para cumplir con el requisito de payload
    # Capturar código HTTP de la descarga también
    curl -s -w "%{http_code}" -H "Authorization: Bearer $AUTH_TOKEN" \
         -H "Content-Type: application/json" \
         -d '{"password": ""}' \
         -X POST "$BASE_URL/backup" -o "$BACKUP_DIR/$FILENAME" > /tmp/backup_http_code

BACKUP_HTTP_CODE=$(cat /tmp/backup_http_code)
rm -f /tmp/backup_http_code

if [ "$BACKUP_HTTP_CODE" -ne 200 ]; then
    echo "[ERROR] Fallo al descargar backup. Código HTTP: $BACKUP_HTTP_CODE"
    echo "[DEBUG] Contenido del archivo (posible error):"
    cat "$BACKUP_DIR/$FILENAME"
    rm -f "$BACKUP_DIR/$FILENAME"
    exit 1
fi

if [ -s "$BACKUP_DIR/$FILENAME" ]; then
    echo "[SUCCESS] Backup guardado exitosamente: $FILENAME ($(du -h "$BACKUP_DIR/$FILENAME" | cut -f1))"
else
    echo "[ERROR] El archivo de backup está vacío."
    rm -f "$BACKUP_DIR/$FILENAME"
    exit 1
fi

# 3. Rotación
echo "[INFO] Verificando backups antiguos para rotación..."
find "$BACKUP_DIR" -name "portainer_backup_*.tar.gz" -mtime +7 -exec rm -v {} \;

echo "[DONE] Proceso de backup finalizado."
