# 🏠 Tofu's Homelab - Docker Infrastructure

A comprehensive, security-focused homelab setup powered by Docker and managed through Portainer, featuring media services, AI tools, home automation, and robust infrastructure components.

## 📋 Overview

This homelab provides a complete self-hosted environment with:
- **Media Server Stack**: Automated media acquisition and streaming (Plex, Jellyfin, *Arr suite)
- **AI Services**: LLM proxy, speech-to-text, and text-to-speech capabilities
- **Home Automation**: Home Assistant ecosystem with Zigbee, Matter, and MQTT
- **Infrastructure**: VPN, DNS, reverse proxy, monitoring, and backups
- **N8N Automation**: Workflow automation
- **Security**: Non-root containers, intelligent restart policies, health monitoring

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Infrastructure │    │   AI Services   │    │   Media Server  │
│    (entrypoint)  │    │      (ai)       │    │   (mediaserver) │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ • Cloudflare    │    │ • LiteLLM        │    │ • Gluetun VPN   │
│ • Cloudflare-DDNS│   │ • Faster-Whisper │    │ • qBittorrent   │
│ • Uptime-Kuma   │    │ • Piper TTS      │    │ • Plex/Jellyfin │
│ • WireGuard VPN │    │ • PostgreSQL     │    │ • *Arr Apps     │
└─────────────────┘    └─────────────────┘    └─────────────────┘

┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ Home Automation │    │  N8N Automation │    │    Backups      │
│ (homeassistant) │    │      (n8n)      │    │    (backups)    │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ • Home Assistant│    │ • N8N           │    │ • Duplicati     │
│ • Mosquitto     │    │ • MCP Proxy     │    │ • Portainer Backup
│ • Zigbee2MQTT   │    │ • PostgreSQL    │    │                 │
│ • Scrypted      │    │ • Cloudflare    │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘

┌─────────────────┐    ┌─────────────────┐
│      Proxy      │    │    Portainer    │
│     (nginx)     │    │   Management    │
├─────────────────┤    ├─────────────────┤
│ • Nginx Proxy   │    │ • Portainer CE  │
│   Manager       │    │ • Web Interface │
│                 │    │ • Auto-updates  │
└─────────────────┘    └─────────────────┘
```

## 🔧 Technology Stack

### Core Components
- **Container Runtime**: Docker & Docker Compose
- **Management UI**: Portainer Community Edition
- **Networking**: Docker bridge networks with inter-stack communication
- **Storage**: Local bind mounts for data persistence
- **Security**: Non-root containers (PUID/PGID 1000), encrypted environment files

### External Dependencies
- **VPN**: Gluetun for secure torrenting
- **DNS/CDN**: Cloudflare for external access and DNS management
- **SSL**: Nginx Proxy Manager / Traefik with Let's Encrypt
- **Domain**: tofusito.org with automated DNS updates

## 📦 Stack Details

### Media Server (mediaserver)
**Purpose**: Automated media acquisition, management, and streaming

| Service | Description | External Access |
|---------|-------------|-----------------|
| Gluetun | VPN client for secure torrenting | Internal only |
| qBittorrent | BitTorrent client | Web UI via VPN |
| Plex | Media streaming server | Direct access |
| Jellyfin | Open source media server | Direct access |
| Sonarr | TV show management | Internal |
| Radarr | Movie management | Internal |
| Prowlarr | Indexer management | Internal |
| Overseerr | Media request management | Web UI |
| Bazarr | Subtitle management | Internal |
| Tautulli | Plex monitoring and statistics | Web UI |

### AI Services (ai)
**Purpose**: Language model proxy and speech processing

| Service | Description | External Access | Health Check |
|---------|-------------|-----------------|-------------|
| LiteLLM | LLM API proxy with multiple providers | API endpoint | Port TCP 4000 |
| Faster-Whisper | Speech-to-text processing | API endpoint | Port TCP 10300 |
| Piper | Text-to-speech synthesis | API endpoint | Port TCP 10200 |
| PostgreSQL | Database for LiteLLM | Internal only | PostgreSQL check |
| Cloudflare | External tunnel access | - | None (minimal) |

### Infrastructure (entrypoint)
**Purpose**: Core infrastructure and monitoring

| Service | Description | External Access | Restart Policy |
|---------|-------------|-----------------|----------------|
| Cloudflare | Main tunnel for external access | - | unless-stopped |
| Cloudflare-DDNS | Dynamic DNS updates | - | always |
| Watchtower | Auto-update containers | - | always |
| Uptime-Kuma | Service monitoring and alerts | Web UI | unless-stopped |
| WireGuard | VPN server for remote access | VPN endpoint | unless-stopped |

### N8N Automation (n8n)
**Purpose**: Workflow automation and integrations

| Service | Description | External Access |
|---------|-------------|-----------------|
| N8N | Workflow automation platform | Web UI via Tunnel |
| MCP Proxy | Model Context Protocol proxy | Internal |
| Cloudflare | Tunnel for external access | - |

### Home Automation (homeassistant)
**Purpose**: Smart home hub and IoT management

| Service | Description |
|---------|-------------|
| Home Assistant | Core home automation platform |
| Mosquitto | MQTT Broker |
| Zigbee2MQTT | Zigbee to MQTT bridge |
| Matter Server | Matter protocol support |
| Ring-MQTT | Ring integration |
| Scrypted | Video security platform |

### Proxy & Web (nginx)
**Purpose**: Reverse proxy management
- **Nginx Proxy Manager**: Easy UI for managing reverse proxy hosts and SSL certificates

### Backups (backups)
**Purpose**: Data protection and disaster recovery
- **Duplicati**: Multi-backend backup solution
- **Portainer Backup**: Automated backups of Portainer configuration

## 🚀 Deployment

### Prerequisites
- Docker and Docker Compose installed
- Sufficient storage space for media and configurations
- Domain name configured with Cloudflare
- VPN provider credentials (for Gluetun)

### Directory Structure

```
/home/tofu/git/homelab/
├── docker/
│   └── stacks/
│       ├── ai/              # AI Services (LiteLLM, Whisper, etc.)
│       ├── backups/         # Backup tools (Duplicati)
│       ├── entrypoint/      # Infra (Cloudflare, Uptime Kuma)
│       ├── homeassistant/   # Home Automation suite
│       ├── mediaserver/     # Plex, Arr suite, VPN
│       ├── n8n/             # N8N Automation
│       └── nginx/           # Nginx Proxy Manager
├── README.md
└── .gitignore
```

## 🔒 Security Features

### Implemented Security Measures
- **Non-root Containers**: All services run with PUID/PGID 1000
- **Intelligent Restart Policies**: Critical services (always) vs normal services (unless-stopped)
- **Encrypted Credentials**: Environment files with restricted permissions (600)
- **VPN-secured Torrenting**: Gluetun prevents IP leaks
- **Health Monitoring**: Automated health checks for critical services
- **Network Isolation**: Proper Docker network segmentation
- **Localhost-only Services**: Database ports restricted to 127.0.0.1

---

**Last Updated**: December 2025
**Maintainer**: Tofu
**Version**: 4.0.0 (Unified Homelab Repository)
