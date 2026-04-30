# 🏠 Tofu's Homelab - Docker Infrastructure

A self-hosted homelab powered by Docker and managed through [Dockhand](https://github.com/FnSys/dockhand), featuring media services, home automation, workflow automation, and networking infrastructure.

> **Public reference note**: This repository documents my personal setup and is shared as a practical reference, not as a plug-and-play distribution. Before reusing anything, replace every `.env` value, review exposed services, adjust domains/IPs/paths, and make your own security decisions for your network.

## 📋 Overview

This homelab provides a complete self-hosted environment with:
- **Media Server Stack**: Automated media acquisition and streaming (Jellyfin, *Arr suite)
- **Home Automation**: Home Assistant ecosystem with Zigbee, Matter, MQTT, and voice
- **Workflow Automation**: N8N with MCP proxy integration
- **Networking**: Tailscale, WireGuard, DNS ad-blocking, reverse proxy, Cloudflare tunnels
- **Finance**: Actual Budget with custom REST API sidecar
- **Development**: Self-hosted Git (Forgejo), personal portfolio
- **AI Agents**: Hermes Telegram bot, OpenClaw coding assistant
- **Security**: Non-root containers, VPN-secured torrenting, network isolation

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│    Dockhand      │    │   Networking    │    │   Media Server  │
│   (dockhand)    │    │  (vpn/tailscale)│    │   (mediaserver) │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ • Dockhand UI   │    │ • WireGuard     │    │ • Gluetun VPN   │
│ • Cloudflare    │    │ • Tailscale     │    │ • qBittorrent   │
│                 │    │ • Cloudflare-DDNS│   │ • Jellyfin      │
│                 │    │ • Pi-hole       │    │ • *Arr suite    │
│                 │    │ • Nginx Proxy   │    │ • Jellyseerr    │
└─────────────────┘    └─────────────────┘    └─────────────────┘

┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ Home Automation │    │  N8N Automation │    │  Actual Budget  │
│ (homeassistant) │    │      (n8n)      │    │ (actualbudget)  │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ • Home Assistant│    │ • N8N           │    │ • Actual Server │
│ • Mosquitto     │    │ • MCP Proxy     │    │ • API Sidecar   │
│ • Zigbee2MQTT   │    │ • Cloudflare    │    │ • Cloudflare    │
│ • Matter Server │    │                 │    │                 │
│ • Wyoming Voice │    │                 │    │                 │
│ • Scrypted      │    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘

┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│      Kakei      │    │    Forgejo      │    │   Portfolio     │
│     (kakei)     │    │   (forgejo)     │    │  (portfolio)    │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ • Kakei App     │    │ • Forgejo Git   │    │ • Portfolio App │
│ • PostgreSQL    │    │ • Cloudflare    │    │ • Cloudflare    │
│ • Cloudflare    │    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘

┌─────────────────┐    ┌─────────────────┐
│    Hermes       │    │    OpenClaw     │
│   (hermes)      │    │   (openclaw)    │
├─────────────────┤    ├─────────────────┤
│ • Hermes Agent  │    │ • Gateway       │
│ • Docker Proxy  │    │ • CLI           │
│                 │    │ • Docker Proxy  │
└─────────────────┘    └─────────────────┘
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

| Service | Description |
|---------|-------------|
| Gluetun | VPN client for secure torrenting |
| qBittorrent | BitTorrent client (routed via Gluetun) |
| Jellyfin | Open source media server |
| Sonarr | TV show management |
| Radarr | Movie management |
| Prowlarr | Indexer management |
| Jellyseerr | Media request management |
| Bazarr | Subtitle management |
| Unpackerr | Automated media extraction |
| Cloudflare | Media tunnel |

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
| Speech-to-Phrase | Wyoming voice recognition |
| Wyoming Piper | Text-to-speech (Spanish) |
| Scrypted | Video security platform |
| Autoheal | Automatic container restart on failure |
| Cloudflare | HA tunnel for external access |

### N8N Automation (`n8n`)
**Purpose**: Workflow automation and integrations

| Service | Description |
|---------|-------------|
| N8N | Workflow automation platform |
| MCP Proxy | Model Context Protocol proxy for HA |
| Cloudflare | Tunnel for external access |

### Actual Budget (`actualbudget`)
**Purpose**: Personal finance tracking with API access

| Service | Description |
|---------|-------------|
| Actual Server | Self-hosted budget application |
| API Sidecar | Custom REST API for Shortcuts/automation |
| Cloudflare | Tunnel for external access |

### Kakei (`kakei`)
**Purpose**: Personal finance tracking (Japanese-style kakeibo)

| Service | Description |
|---------|-------------|
| Kakei | Finance tracking web app |
| PostgreSQL | Database backend |
| Cloudflare | Tunnel for external access |

### Forgejo (`forgejo`)
**Purpose**: Self-hosted Git service

| Service | Description |
|---------|-------------|
| Forgejo | Lightweight self-hosted Git platform |
| Cloudflare | Tunnel for external access |

### Portfolio (`portfolio`)
**Purpose**: Personal portfolio website

| Service | Description |
|---------|-------------|
| Portfolio | Static site (custom Docker image) |
| Cloudflare | Tunnel for external access |

### Hermes (`hermes`)
**Purpose**: AI agent accessible via Telegram

| Service | Description |
|---------|-------------|
| Hermes | AI agent with Docker and HA integration |
| Docker Proxy | Read-only Docker socket proxy |

### OpenClaw (`openclaw`)
**Purpose**: AI-powered coding assistant

| Service | Description |
|---------|-------------|
| Gateway | OpenClaw backend service |
| CLI | Interactive terminal client |
| Docker Proxy | Read-only Docker socket proxy |

### VPN Services (`vpn`)
**Purpose**: Remote access and dynamic DNS

| Service | Description |
|---------|-------------|
| WireGuard | VPN server for remote access |
| Cloudflare-DDNS | Dynamic DNS updates |

### Tailscale (`tailscale`)
**Purpose**: Mesh VPN and subnet router

| Service | Description |
|---------|-------------|
| Tailscale | Mesh VPN with subnet routing (192.168.31.0/24) |

### Pi-hole (`pihole`)
**Purpose**: Network-wide DNS ad-blocking

| Service | Description |
|---------|-------------|
| Pi-hole | DNS sinkhole for ad-blocking |

### Nginx Proxy Manager (`nginx`)
**Purpose**: Reverse proxy and SSL management

| Service | Description |
|---------|-------------|
| Nginx Proxy Manager | Reverse proxy with SSL |

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
│   │   └── gluetun/         # Custom Gluetun build
│   └── stacks/
│       ├── actualbudget/    # Actual Budget + API sidecar
│       ├── dockhand/        # Stack management + main tunnel
│       ├── forgejo/         # Self-hosted Git
│       ├── hermes/          # Telegram AI agent
│       ├── homeassistant/   # Home Automation suite
│       ├── kakei/           # Personal finance app
│       ├── mediaserver/     # Jellyfin, Arr suite, VPN
│       ├── n8n/             # Workflow automation
│       ├── nginx/           # Nginx Proxy Manager
│       ├── openclaw/        # AI coding assistant
│       ├── pihole/          # DNS ad-blocking
│       ├── portfolio/       # Personal portfolio
│       ├── tailscale/       # Mesh VPN
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
- **Docker socket proxies**: Hermes and OpenClaw access Docker via read-only socket proxies
- **Health monitoring**: Health checks on critical services (Pi-hole, WireGuard, qBittorrent, N8N, Actual Budget, Forgejo)

---

**Last Updated**: April 2026
**Maintainer**: Tofu
