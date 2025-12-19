FROM alpine:latest

# Instalar dependencias necesarias: bash (para el script), curl (para la API), jq (para procesar JSON)
RUN apk add --no-cache bash curl jq

# Copiar scripts
COPY backup.sh /usr/local/bin/backup.sh
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/backup.sh /usr/local/bin/entrypoint.sh

# Configurar Cron: 
# Ejecutar a las 03:00 AM todos los Domingos (0 3 * * 0)
# Se redirige stdout y stderr a los descriptores de archivo del proceso principal (PID 1) para ver logs con 'docker logs'
RUN echo "0 3 * * 0 /usr/local/bin/backup.sh > /proc/1/fd/1 2>/proc/1/fd/2" > /etc/crontabs/root

# Usar script de entrada personalizado para verificar estado inicial
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
