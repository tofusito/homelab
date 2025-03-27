# Docker Homelab Stacks

Este repositorio contiene una colección de stacks de Docker Compose para un homelab personal. Cada stack está organizado en su propio directorio y contiene un archivo `docker-compose.yaml` y opcionalmente un archivo `.env.example`.

## Stacks disponibles

- **ai**: Servicios de procesamiento de voz (reconocimiento y síntesis)
- **entrypoint**: Servicios de entrada y gestión de acceso
- **mediaserver**: Conjunto completo de servicios para gestionar y servir contenido multimedia
- **openwebui**: Interfaz web para servicios AI/LLM
- **theroompro**: Servicios adicionales

## Requisitos previos

- Docker y Docker Compose instalados
- Espacio suficiente en disco para almacenar los datos
- Conocimientos básicos de Docker y networking

## Configuración

1. Clona este repositorio:
   ```bash
   git clone https://github.com/tu-usuario/homelab-docker-stacks.git
   cd homelab-docker-stacks
   ```

2. Para cada stack que quieras usar:
   - Copia el archivo `.env.example` a `.env`
   - Edita el archivo `.env` con tus propias credenciales y configuraciones
   - Define la variable `DATA_DIR` para indicar dónde se almacenarán los datos (importante para Portainer)
   ```bash
   cd docker/stacks/mediaserver
   cp .env.example .env
   nano .env
   ```

   Ejemplo de configuración en .env:
   ```
   DATA_DIR=/path/to/your/data
   TUNNEL_TOKEN=your_cloudflare_tunnel_token
   ...
   ```

3. Creación de directorios:
   - Todos los datos se almacenarán en la ruta especificada en la variable `DATA_DIR`
   - Los directorios se crearán automáticamente si no existen

## Uso con Portainer

Cuando uses estos stacks con Portainer:

1. En la sección de "Stacks", crea un nuevo stack
2. Sube el archivo `docker-compose.yaml` o apunta al repositorio git
3. En la sección de variables de entorno, asegúrate de definir `DATA_DIR` con la ruta absoluta donde quieres almacenar los datos
4. Esta configuración hace fácil gestionar los volúmenes sin tener que preocuparte por rutas relativas

## Uso

Para iniciar un stack:

```bash
cd docker/stacks/mediaserver
docker-compose up -d
```

Para detener un stack:

```bash
cd docker/stacks/mediaserver
docker-compose down
```

## Estructura de directorios

Cada stack sigue una estructura similar, pero los datos se almacenan según la variable `DATA_DIR`:

```
$DATA_DIR/
├── open-webui/      # Datos de Open WebUI
├── chroma/          # Datos de Chroma DB
├── plex/            # Configuración de Plex
├── sonarr/          # Configuración de Sonarr
└── ...              # Otros servicios
```

## Notas de seguridad

- **NUNCA** subas tus archivos `.env` con credenciales reales a un repositorio público
- Usa siempre los archivos `.env.example` para la documentación
- Asegúrate de que tus volúmenes de Docker estén protegidos adecuadamente

## Servicios VPN

Algunos servicios están configurados para funcionar a través de una VPN (gluetun). Asegúrate de configurar correctamente las variables de entorno relacionadas con tu proveedor de VPN.

## Contribuciones

Las contribuciones son bienvenidas. Por favor, asegúrate de seguir las prácticas de seguridad adecuadas y no incluir información sensible o personal.

## Licencia

Este proyecto se distribuye bajo la licencia MIT. Consulta el archivo LICENSE para más detalles. 