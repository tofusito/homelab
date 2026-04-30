# Hermes stack

Hermes queda montado como asistente aislado para un vault dedicado:

- Estado del contenedor: `/home/tofu/docker/hermes/data`
- Vault dedicado: `/mnt/evo/Obsidian/Hermes`

El vault completo se monta en lectura/escritura dentro del contenedor como `/workspace/vault`.
La outbox vive dentro del vault como `/workspace/vault/00_Inbox/Hermes`.
MediaServer y Downloads se montan en:

- `/workspace/media/MediaServer`
- `/workspace/media/Downloads`

No se publica ningun puerto, no se monta el socket Docker y no se usa `network_mode: host`.
Hermes accede a Docker mediante `hermes-docker-proxy`, no con el socket directo.

Permisos Docker habilitados:

- inspeccionar contenedores, imagenes, redes, volumenes, info y eventos
- arrancar, parar y reiniciar contenedores existentes
- `POST=0`, sin build, exec, secrets, swarm ni system

Crear contenedores nuevos o recrear stacks para actualizar servicios debe pedirse primero.

## Vault

Estructura top-level esperada:

```text
00_Inbox/
01_Projects/
02_Areas/
03_Resources/
04_Archive/
05_Attachments/
```

No hay carpeta `6. SKILLS` en este vault. Los adjuntos que reciba Hermes deben ir a `05_Attachments/`.

## LLM

El stack pasa estas variables opcionales al contenedor:

- `KIMI_API_KEY`
- `KIMI_BASE_URL`
- `DEEPSEEK_API_KEY`
- `DEEPSEEK_BASE_URL`

La configuracion persistente de Hermes vive en `/home/tofu/docker/hermes/data/config.yaml`.
Por defecto se deja preparada para Kimi:

```yaml
model:
  default: "kimi-k2.6"
  provider: "kimi-coding"
  base_url: "https://api.kimi.com/coding/v1"
```

Para usar DeepSeek, rellena `DEEPSEEK_API_KEY` en `.env` y cambia esos campos a:

```yaml
model:
  default: "deepseek-chat"
  provider: "deepseek"
  base_url: "https://api.deepseek.com/v1"
```
