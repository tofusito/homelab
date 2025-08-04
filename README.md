# 🏠 Tofu's Homelab - Docker Infrastructure

A comprehensive, security-focused homelab setup powered by Docker and managed through Portainer, featuring media services, AI tools, and infrastructure components.

## 📋 Overview

This homelab provides a complete self-hosted environment with:
- **Media Server Stack**: Automated media acquisition and streaming
- **AI Services**: LLM proxy, speech-to-text, and text-to-speech capabilities  
- **Infrastructure**: VPN, DNS, monitoring, and web UI management
- **N8N Automation**: Workflow automation with Traefik reverse proxy
- **Security**: Non-root containers, intelligent restart policies, health monitoring

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Infrastructure │    │   AI Services   │    │   Media Server  │
│   (Stack 65)     │    │   (Stack 55)    │    │   (Stack 4)     │
├─────────────────┤    ├─────────────────┤    ├─────────────────┤
│ • Cloudflare    │    │ • LiteLLM        │    │ • Gluetun VPN   │
│ • Cloudflare-DDNS│   │ • Faster-Whisper │    │ • qBittorrent   │
│ • Uptime-Kuma   │    │ • Piper TTS      │    │ • Plex          │
│ • WireGuard VPN │    │ • PostgreSQL     │    │ • Sonarr        │
└─────────────────┘    └─────────────────┘    │ • Radarr        │
                                              │ • Prowlarr      │
┌─────────────────┐    ┌─────────────────┐    │ • Overseerr     │
│   Open WebUI    │    │  N8N Automation │    │ • Bazarr        │
│   (Stack 62)    │    │   (Stack 74)    │    │ • Tautulli      │
├─────────────────┤    ├─────────────────┤    └─────────────────┘
│ • Open-WebUI    │    │ • Traefik       │
│ • ChromaDB      │    │ • N8N           │    ┌─────────────────┐
│ • MCPO          │    │ • PostgreSQL    │    │    Portainer    │
│ • Cloudflare    │    │ • Cloudflare    │    │   Management    │
└─────────────────┘    └─────────────────┘    ├─────────────────┤
                                              │ • Portainer CE  │
                                              │ • Web Interface │
                                              │ • Auto-updates  │
                                              └─────────────────┘
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
- **SSL**: Traefik with Let's Encrypt + Cloudflare managed certificates
- **Domain**: tofusito.org with automated DNS updates

## 📦 Stack Details

### Stack 4: Media Server (MediaServer)
**Purpose**: Automated media acquisition, management, and streaming

| Service | Description | External Access |
|---------|-------------|-----------------|
| Gluetun | VPN client for secure torrenting | Internal only |
| qBittorrent | BitTorrent client | Web UI via VPN |
| Plex | Media streaming server | Direct access |
| Sonarr | TV show management | Internal |
| Radarr | Movie management | Internal |
| Prowlarr | Indexer management | Internal |
| Overseerr | Media request management | Web UI |
| Bazarr | Subtitle management | Internal |
| Tautulli | Plex monitoring and statistics | Web UI |

**Key Features**:
- VPN-secured torrenting through Gluetun
- Automated media acquisition pipeline
- Comprehensive media library management
- Request system for users

### Stack 55: AI Services (AI)
**Purpose**: Language model proxy and speech processing

| Service | Description | External Access | Health Check |
|---------|-------------|-----------------|-------------|
| LiteLLM | LLM API proxy with multiple providers | API endpoint | Port TCP 4000 |
| Faster-Whisper | Speech-to-text processing | API endpoint | Port TCP 10300 |
| Piper | Text-to-speech synthesis | API endpoint | Port TCP 10200 |
| PostgreSQL | Database for LiteLLM | Internal only | PostgreSQL check |
| Cloudflare | External tunnel access | - | None (minimal) |

**Key Features**:
- Multi-provider LLM access through single API
- High-performance speech processing with optimized health monitoring
- Shared database for persistent configurations
- External access via Cloudflare tunnel
- **Optimized Health Checks**: Simple TCP port verification for reliable monitoring

### Stack 62: Open WebUI
**Purpose**: Web interface for AI interactions

| Service | Description | External Access |
|---------|-------------|-----------------|
| Open-WebUI | ChatGPT-like web interface | Web UI |
| ChromaDB | Vector database for embeddings | Internal only |
| MCPO | Model completion proxy | Internal only |
| Cloudflare | External tunnel access | - |

**Key Features**:
- Modern chat interface for LLM interactions
- Integration with Stack 55's LiteLLM service
- Vector search capabilities
- External access via Cloudflare tunnel

### Stack 65: Infrastructure
**Purpose**: Core infrastructure and monitoring

| Service | Description | External Access | Restart Policy | Health Check |
|---------|-------------|-----------------|----------------|-------------|
| Cloudflare | Main tunnel for external access | - | unless-stopped | None (minimal) |
| Cloudflare-DDNS | Dynamic DNS updates | - | always | None (minimal) |
| Uptime-Kuma | Service monitoring and alerts | Web UI | unless-stopped | Built-in |
| WireGuard | VPN server for remote access | VPN endpoint | unless-stopped | WireGuard check |

**Key Features**:
- Secure external access through Cloudflare tunnels
- Critical Dynamic DNS service (always running)
- Comprehensive service monitoring
- Self-hosted VPN for remote management
- **Optimized for Minimal Containers**: No health checks for ultra-lightweight Cloudflare services

### Stack 74: N8N Automation
**Purpose**: Workflow automation and reverse proxy

| Service | Description | External Access | Restart Policy |
|---------|-------------|-----------------|----------------|
| Traefik | Reverse proxy with SSL automation | Web proxy | always |
| N8N | Workflow automation platform | Web UI via Traefik | unless-stopped |
| PostgreSQL | Database for N8N workflows | Internal only | unless-stopped |
| Cloudflare | Tunnel for external access | - | unless-stopped |

**Key Features**:
- Professional reverse proxy with automatic SSL
- Workflow automation and integrations
- Secure external access via n8n.tofusito.org
- Production-ready database backend

## 🚀 Deployment

### Prerequisites
- Docker and Docker Compose installed
- Sufficient storage space for media and configurations
- Domain name configured with Cloudflare
- VPN provider credentials (for Gluetun)

### Installation Steps

1. **Clone/Download Configuration**
   ```bash
   # Ensure directory structure exists
   mkdir -p /home/tofu/docker/portainer
   mkdir -p /home/tofu/docker/{media,downloads}
   ```

2. **Start Portainer**
   ```bash
   cd Docker
   docker compose -f docker-portainer.yaml up -d
   ```

3. **Access Portainer Web Interface**
   - Navigate to `http://localhost:9000`
   - Create admin account
   - Connect to local Docker environment

4. **Deploy Stacks in Order**
   
   Deploy the following stacks through Portainer UI in this specific order:
   
   1. **Stack 65 (Infrastructure)** - Core services and external access
   2. **Stack 74 (N8N Automation)** - Traefik proxy and N8N workflows
   3. **Stack 55 (AI Services)** - LLM and speech processing
   4. **Stack 4 (MediaServer)** - Media acquisition and streaming
   5. **Stack 62 (OpenWebUI)** - Web interface (connects to Stack 55)

### Environment Configuration

Each stack requires environment variables in `stack.env` files:

- **Stack 4**: VPN credentials, media paths
- **Stack 55**: API keys for LLM providers, PostgreSQL credentials
- **Stack 62**: Database connections, API endpoints
- **Stack 65**: Cloudflare tokens, monitoring credentials
- **Stack 74**: Domain configuration, SSL email, PostgreSQL credentials, Cloudflare tunnel token

⚠️ **Security Note**: All `stack.env` files are configured with `600` permissions for security.

## 🔒 Security Features

### Implemented Security Measures
- **Non-root Containers**: All services run with PUID/PGID 1000
- **Intelligent Restart Policies**: Critical services (always) vs normal services (unless-stopped)
- **Encrypted Credentials**: Environment files with restricted permissions (600)
- **VPN-secured Torrenting**: Gluetun prevents IP leaks
- **Health Monitoring**: Automated health checks for critical services
- **Network Isolation**: Proper Docker network segmentation
- **Localhost-only Services**: Database ports restricted to 127.0.0.1

### Removed Security Risks
- ✅ Eliminated root-privileged containers
- ✅ Removed insecure services (dash, homarr)
- ✅ Optimized service restart behavior
- ✅ Secured credential storage
- ✅ Cleaned up obsolete configurations (28 directories removed)

## 🔄 Maintenance & Updates

### Automatic Updates
All services with `latest` tags are configured with `pull_policy: always` to automatically download the latest images on restart (17+ services total).

### Manual Updates
```bash
# Update specific stack
cd /home/tofu/docker/portainer/compose/[STACK_NUMBER]
docker compose --env-file stack.env pull
docker compose --env-file stack.env up -d
```

### Health Monitoring
- **Intelligent Health Checks**: TCP port verification for reliable monitoring
- **Optimized for Container Types**: No health checks for minimal containers
- **Service-Specific Monitoring**:
  - AI Services: TCP port checks (4000, 10300, 10200)
  - Databases: Native PostgreSQL health checks
  - Media Services: Application-specific health checks
  - Cloudflare Services: No health checks (ultra-minimal containers)
- Uptime-Kuma provides comprehensive external monitoring
- Automatic restart policies ensure service availability

## 🌐 Access Information

### Web Interfaces
| Service | URL | Purpose |
|---------|-----|---------|
| Portainer | `http://localhost:9000` | Container management |
| Plex | `http://localhost:32400` | Media streaming |
| Overseerr | `http://localhost:5055` | Media requests |
| N8N | `https://n8n.tofusito.org` | Workflow automation |
| Open-WebUI | Via Cloudflare tunnel | AI chat interface |
| Uptime-Kuma | Via Cloudflare tunnel | Service monitoring |
| WireGuard | `https://vpn.tofusito.org` | VPN management |

### API Endpoints
| Service | Endpoint | Purpose |
|---------|----------|---------|
| LiteLLM | `http://localhost:4000` | LLM API proxy |
| Faster-Whisper | `http://localhost:10300` | Speech-to-text |
| Piper | `http://localhost:10200` | Text-to-speech |

## 🗂️ Directory Structure

```
/home/tofu/docker/
├── portainer/           # Portainer data and compose files
│   ├── compose/         # Stack definitions
│   │   ├── 4/          # MediaServer stack
│   │   ├── 55/         # AI Services stack
│   │   ├── 62/         # OpenWebUI stack
│   │   ├── 65/         # Infrastructure stack
│   │   └── 74/         # N8N Automation stack
│   └── data/           # Portainer application data
├── media/              # Media storage
├── downloads/          # Download directory
├── n8n/                # N8N workflows and data
├── uk/                 # Uptime-Kuma database
├── volumes/            # Docker volumes (ChromaDB, PostgreSQL)
├── plex/               # Plex configuration
├── sonarr/             # Sonarr configuration
├── radarr/             # Radarr configuration
├── qbittorrent/        # qBittorrent configuration
└── [service]/          # Individual service configurations
```

## 🛠️ Troubleshooting

### Common Issues

**Portainer not accessible**
- Verify container is running: `docker ps | grep portainer`
- Check port binding: `netstat -tlnp | grep :9000`

**Stack deployment fails**
- Check environment file permissions: `ls -la stack.env`
- Verify all required directories exist
- Review Docker logs: `docker logs [container_name]`

**Services showing as unhealthy**
- **AI Services**: Verify TCP ports are accessible (4000, 10300, 10200)
- **Cloudflare Services**: No health checks by design (minimal containers)
- **Databases**: Check PostgreSQL connectivity
- **False Negatives**: Health checks are optimized to prevent false alarms

**Network connectivity issues**
- Verify Docker networks: `docker network ls`
- Check inter-stack communication
- Validate Cloudflare tunnel configuration

### Service Dependencies
1. Infrastructure stack must be deployed first
2. N8N Automation stack provides reverse proxy for other services
3. AI Services stack requires database initialization
4. OpenWebUI stack depends on AI Services LiteLLM endpoint
5. Media stack requires VPN configuration

### Restart Policy Strategy
**Critical Services (restart: always)**:
- Traefik (reverse proxy - entry point)
- Cloudflare-DDNS (maintains external connectivity)

**Normal Services (restart: unless-stopped)**:
- All applications, databases, and backup tunnels
- Provides manual control while maintaining automatic restart on failures

### Health Check Strategy
**TCP Port Verification (AI Services)**:
- Simple, reliable, and fast
- LiteLLM: Port 4000
- Faster-Whisper: Port 10300
- Piper: Port 10200

**No Health Checks (Minimal Containers)**:
- Cloudflare services: Ultra-minimal containers without standard tools
- Better performance and no false negatives

**Native Health Checks (Databases)**:
- PostgreSQL: Built-in health verification
- Application-specific checks for complex services

## 📊 Performance & Resource Usage

### Estimated Resource Requirements
- **CPU**: 4-8 cores recommended for transcoding and AI processing
- **RAM**: 16GB minimum (32GB recommended for AI workloads)
- **Storage**: 
  - 100GB for configurations and containers
  - Additional storage for media library (varies by usage)
- **Network**: Gigabit recommended for 4K streaming and external access

### Optimization Features
- **Intelligent restart policies**: Critical services always up, others respect manual control
- **Automatic updates**: 17+ services with pull_policy: always
- **Smart health monitoring**: 
  - TCP port checks for AI services (reliable and fast)
  - No health checks for minimal containers (optimal performance)
  - PostgreSQL native checks for databases
  - Application-specific checks where beneficial
- **Security hardening**: PUID 1000, localhost-only ports, encrypted credentials
- **Clean architecture**: 28 obsolete directories removed, optimized structure
- **Efficient networking**: Optimized Docker network configuration
- **Container-optimized monitoring**: Health checks tailored to container capabilities

## 🤝 Contributing

To modify or extend this homelab:

1. **Edit configurations** through Portainer UI or local files
2. **Test changes** in development environment first
3. **Update documentation** when adding new services
4. **Follow security best practices** for new components

## 📄 License

This homelab configuration is provided as-is for personal use. Ensure compliance with all software licenses for individual components.

---

**Last Updated**: August 2025  
**Maintainer**: Tofu  
**Version**: 3.0.1 (Enterprise-Grade with Optimized Health Monitoring)

### Recent Optimizations (v3.0)
- ✅ Added N8N Automation stack with Traefik reverse proxy
- ✅ Implemented intelligent restart policies (always vs unless-stopped)
- ✅ Added automatic updates to 17+ services
- ✅ **Optimized health monitoring strategy**:
  - TCP port checks for AI services (LiteLLM, Faster-Whisper, Piper)
  - Removed problematic health checks from minimal containers
  - Maintained native checks for databases and complex services
- ✅ Cleaned and optimized directory structure (-58% reduction)
- ✅ Hardened security with localhost-only database ports
- ✅ Optimized PostgreSQL configuration for AI workloads
- ✅ **Final health check optimization**: Eliminated false negatives and improved reliability