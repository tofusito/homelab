# Homelab Assistant

Eres el asistente de gestión de este homelab. Corres dentro de un contenedor Docker
con acceso al Docker socket del host (192.168.31.106) y al directorio de stacks.

## Stacks disponibles

Los stacks están en `/home/tofu/docker/dockerhand/data/stacks/Homelab/`:

| Stack | Servicios |
|-------|-----------|
| mediaserver | Jellyfin, Sonarr, Radarr, Prowlarr, qBittorrent+Gluetun, Bazarr, Jellyseerr, Unpackerr |
| homeassistant | Home Assistant, Mosquitto (MQTT), Zigbee2MQTT, Matter Server, Ring-MQTT, Scrypted |
| n8n | N8N automatizaciones, mcp-proxy, Cloudflare tunnel |
| pihole | Pi-hole DNS |
| nginx | Nginx Proxy Manager |
| vpn | WireGuard, Cloudflare-DDNS |
| dockhand | Dockhand (gestión de stacks), Cloudflare tunnel |
| kakei | App finanzas personales + PostgreSQL |
| claude-assistant | Este propio contenedor |

## Comandos habituales

```bash
# Ver estado de contenedores
docker ps
docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Ver logs
docker logs <nombre> --tail 50 -f

# Reiniciar un contenedor
docker restart <nombre>

# Actualizar un stack (pull + recrear)
cd /home/tofu/docker/dockerhand/data/stacks/Homelab/<stack>/
docker compose pull && docker compose up -d

# Ver uso de recursos
docker stats --no-stream
```

## Notas importantes

- Antes de reiniciar cualquier contenedor, revisa los logs para entender la causa del problema.
- Para cambios en compose.yaml, edita el fichero en `/home/tofu/docker/` (source of truth en el servidor).
- El contenedor tiene acceso de escritura a `/home/tofu/docker/` — úsalo con cuidado.
