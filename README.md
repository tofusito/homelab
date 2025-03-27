# 🏠 Docker Homelab Stacks

This repository contains a collection of Docker Compose stacks for a personal homelab. Each stack is organized in its own directory and includes a `docker-compose.yaml` file and an optional `.env.example` file.

## 🧩 Available Stacks

- **🎙️ AI** - Voice processing services:
  - `faster-whisper`: Speech-to-text transcription service (Spanish)
  - `piper`: Text-to-speech synthesis service

- **🚪 Entrypoint** - Access management services:
  - `cloudflare`: Cloudflare tunnel for secure remote access
  - `cloudflare-ddns`: Dynamic DNS updates for Cloudflare domains
  - `twingate_connector`: Secure network access solution
  - `homarr`: Dashboard for your services
  - `dash`: System monitoring dashboard
  - `uptime-kuma`: Uptime monitoring
  - `wireguard`: VPN service

- **🎬 Mediaserver** - Complete media management solution:
  - `gluetun`: VPN container with port forwarding
  - `qbittorrent`: Torrent client
  - `plex` & `jellyfin`: Media servers
  - `sonarr`: TV series management
  - `radarr`: Movie management
  - `prowlarr`: Indexer manager
  - `overseerr`: Media request interface
  - `bazarr`: Subtitle management
  - `tautulli`: Plex monitoring
  - `cloudflare`: External access tunnel

- **🌐 OpenWebUI** - Web interface for AI/LLM services:
  - `open-webui`: Main interface for LLMs
  - `litellm`: Proxy for LLM APIs
  - `chroma`: Vector database
  - `searxng`: Meta search engine
  - `caddy`: Web server
  - `redis`: In-memory database

- **🏢 TheRoomPro** - Additional services

## 🧰 Prerequisites

- 🐳 Docker and Docker Compose installed
- 💽 Sufficient disk space for storing data
- 🔌 Basic knowledge of Docker and networking
- 🌐 Internet connection for pulling images

## ⚙️ Configuration

1. 📥 Clone this repository:
   ```bash
   git clone https://github.com/your-username/homelab-docker-stacks.git
   cd homelab-docker-stacks
   ```

2. 🔧 For each stack you want to use:
   - Copy the `.env.example` file to `.env`
   - Edit the `.env` file with your own credentials and configurations
   - Define the `DATA_DIR` variable to specify where the data will be stored (important for Portainer)
   ```bash
   cd docker/stacks/mediaserver
   cp .env.example .env
   nano .env
   ```

   Example `.env` configuration:
   ```
   DATA_DIR=/path/to/your/data
   TUNNEL_TOKEN=your_cloudflare_tunnel_token
   ...
   ```

3. 📁 Directory Creation:
   - All data will be stored in the path specified in the `DATA_DIR` variable
   - Directories will be created automatically if they don't exist
   - Make sure the user running the containers has write permissions to this directory

## 🐋 Usage with Portainer

When using these stacks with Portainer:

1. In the "Stacks" section, create a new stack
2. Upload the `docker-compose.yaml` file or point to the git repository
3. In the environment variables section, make sure to define `DATA_DIR` with the absolute path where you want to store the data
4. This configuration makes it easy to manage volumes without worrying about relative paths
5. The same stack definition can be used across different hosts by just changing the `DATA_DIR` variable

## 🚀 Usage

To start a stack:

```bash
cd docker/stacks/mediaserver
docker-compose up -d
```

To stop a stack:

```bash
cd docker/stacks/mediaserver
docker-compose down
```

To view logs:

```bash
docker-compose logs -f [service_name]
```

To update a stack:

```bash
docker-compose pull
docker-compose up -d
```

## 📂 Directory Structure

Each stack follows a similar structure, but the data is stored according to the `DATA_DIR` variable:

```
$DATA_DIR/
├── open-webui/      # Open WebUI data
├── chroma/          # Chroma DB data
├── plex/            # Plex configuration
├── sonarr/          # Sonarr configuration
├── whisper/         # Whisper configuration
├── piper/           # Piper configuration
├── homarr/          # Homarr configuration
├── wireguard/       # WireGuard configuration
└── ...              # Other services
```

## 🔒 Security Notes

- ⚠️ **NEVER** upload your `.env` files with real credentials to a public repository
- 📝 Always use `.env.example` files for documentation
- 🛡️ Make sure your Docker volumes are properly protected
- 🔑 Use strong passwords for all services
- 🔐 Consider using a separate network for sensitive services
- 🧪 Regularly test your security configurations

## 🌍 VPN Services

Some services are configured to work through a VPN (gluetun):

- Ensures your traffic is encrypted and private
- Provides port forwarding for remote access
- Make sure to properly configure environment variables related to your VPN provider
- Supported VPN providers include ProtonVPN, NordVPN, and others

## 🛠️ Advanced Configuration

### 🔄 Network Configuration

The stacks define several Docker networks:
- `homelab`: General network for most services
- `mediaserver`: Specific network for media services
- `ai`: Network for AI/voice services
- `openwebui`: Network for LLM/web services

External networks:
- `portainer_bridge`: Used to connect to Portainer services

### 🎛️ Resource Limits

Consider adding resource limits to the services if running on limited hardware:

```yaml
services:
  your-service:
    # ...other config
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
```

## 👥 Contributing

Contributions are welcome! Please ensure you follow these guidelines:

- Follow proper security practices
- Do not include sensitive or personal information
- Test your changes before submitting
- Document your changes clearly
- Create a pull request with a clear description

## 📜 License

This project is distributed under the MIT License. See the LICENSE file for more details.

## 🙏 Acknowledgements

- The Docker and Docker Compose teams
- All the open-source projects that make this homelab possible
- The homelab community for inspiration and support 