# 🏠 Tofu's Homelab - Docker Infrastructure

A self-hosted homelab powered by Docker and managed through [Dockhand](https://github.com/FnSys/dockhand), featuring media services, home automation, workflow automation, and networking infrastructure.

## 📋 Overview

This homelab provides a complete self-hosted environment with:
- **Media Server Stack**: Automated media acquisition and streaming (Jellyfin, *Arr suite)
- **Home Automation**: Home Assistant ecosystem with Zigbee, Matter, and MQTT
- **Workflow Automation**: N8N with MCP proxy integration
- **Networking**: VPN, DNS ad-blocking, reverse proxy, Cloudflare tunnels
- **Security**: Non-root containers, VPN-secured torrenting, network isolation

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│    Dockhand      │    │   VPN Services  │    │   Media Server  │
│   (dockhand)    │    │      (vpn)      │    │   (mediaserver) │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ • Dockhand UI   │    │ • WireGuard     │    │ • Gluetun VPN   │
│ • Cloudflare    │    │ • Cloudflare-DDNS│   │ • qBittorrent   │
│                 │    │                 │    │ • Jellyfin       │
│                 │    │                 │    │ • *Arr/Jellyseerr│
└─────────────────┘    └─────────────────┘    └─────────────────┘

┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   DNS / Proxy   │    │ Home Automation │    │  N8N Automation │
│ (pihole / nginx)│    │ (homeassistant) │    │      (n8n)      │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ • Pi-hole       │    │ • Home Assistant│    │ • N8N           │
│ • Nginx Proxy   │    │ • Mosquitto     │    │ • MCP Proxy     │
│   Manager       │    │ • Zigbee2MQTT   │    │ • Cloudflare    │
│                 │    │ • Matter Server │    │                 │
│                 │    │ • Scrypted      │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘

┌─────────────────┐
│      Kakei      │
│     (kakei)     │
├─────────────────┤
│ • Kakei App     │
│ • PostgreSQL    │
│ • Cloudflare    │
└─────────────────┘
```

## 📦 Stack Details

### Dockhand (`dockhand`)
**Purpose**: Stack management UI and main Cloudflare tunnel

| Service | Description |
|---------|-------------|
| Dockhand | Docker stack management interface |
| Cloudflare | Main tunnel for external access |

### Media Server (`mediaserver`)
**Purpose**: Automated media acquisition, management, and streaming

| Service | Description | Access |
|---------|-------------|--------|
| Gluetun | VPN client for secure torrenting | Internal |
| qBittorrent | BitTorrent client | Web UI via VPN |
| Jellyfin | Open source media server | Host network |
| Sonarr | TV show management | Via Gluetun |
| Radarr | Movie management | Via Gluetun |
| Prowlarr | Indexer management | Via Gluetun |
| Jellyseerr | Media request management | Web UI |
| Bazarr | Subtitle management | Web UI |
| Unpackerr | Automated media extraction | Internal |
| Cloudflare | Media tunnel | - |

### Home Automation (`homeassistant`)
**Purpose**: Smart home hub and IoT management

| Service | Description |
|---------|-------------|
| Home Assistant | Core home automation platform |
| Mosquitto | MQTT broker |
| Zigbee2MQTT | Zigbee to MQTT bridge |
| Matter Server | Matter protocol support |
| Matter Bridge | Home Assistant Matter Hub |
| Ring-MQTT | Ring integration via MQTT |
| Scrypted | Video security platform |
| Cloudflare | HA tunnel for external access |

### N8N Automation (`n8n`)
**Purpose**: Workflow automation and integrations

| Service | Description |
|---------|-------------|
| N8N | Workflow automation platform |
| MCP Proxy | Model Context Protocol proxy for HA |
| Cloudflare | Tunnel for external access |

### Pi-hole (`pihole`)
**Purpose**: Network-wide DNS ad-blocking

| Service | Description |
|---------|-------------|
| Pi-hole | DNS sinkhole for ad-blocking |

### VPN Services (`vpn`)
**Purpose**: Remote access and dynamic DNS

| Service | Description |
|---------|-------------|
| WireGuard | VPN server for remote access |
| Cloudflare-DDNS | Dynamic DNS updates |

### Nginx Proxy Manager (`nginx`)
**Purpose**: Reverse proxy and SSL management

| Service | Description |
|---------|-------------|
| Nginx Proxy Manager | Reverse proxy with SSL |

### Kakei (`kakei`)
**Purpose**: Personal finance tracking

| Service | Description |
|---------|-------------|
| Kakei | Finance tracking web app |
| PostgreSQL | Database backend |
| Cloudflare | Tunnel for external access |

## 🚀 Deployment

### Prerequisites
- Docker and Docker Compose installed
- Domain name configured with Cloudflare
- VPN provider credentials (for Gluetun)

### Directory Structure

```
homelab/
├── docker/
│   ├── images/              # Custom Docker images
│   │   ├── gluetun/         # Custom Gluetun build
│   │   └── portainer-backup/# Legacy backup tool
│   └── stacks/
│       ├── dockhand/        # Stack management + main tunnel
│       ├── homeassistant/   # Home Automation suite
│       ├── kakei/           # Personal finance app
│       ├── mediaserver/     # Jellyfin, Arr suite, VPN
│       ├── n8n/             # Workflow automation
│       ├── nginx/           # Nginx Proxy Manager
│       ├── pihole/          # DNS ad-blocking
│       └── vpn/             # WireGuard + DDNS
├── README.md
└── .gitignore
```

### Stack File Convention
- `compose.yaml` — Docker Compose configuration
- `.env.example` — Environment variables template (no secrets)
- `.env` — Actual environment variables (gitignored)

## 🔒 Security

- **Non-root containers**: Services run with PUID/PGID 1000
- **VPN-secured torrenting**: All *Arr and torrent traffic routed through Gluetun
- **Network isolation**: Docker bridge networks with inter-stack communication where needed
- **Cloudflare tunnels**: Secure external access without exposing ports
- **Secrets management**: `.env` files gitignored, `.env.example` with placeholders committed
- **Health monitoring**: Health checks on critical services (Pi-hole, WireGuard, qBittorrent, N8N)

---

**Last Updated**: February 2026
**Maintainer**: Tofu
