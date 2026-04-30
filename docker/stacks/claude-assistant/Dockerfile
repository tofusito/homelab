FROM node:20-slim

RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    git \
    procps \
    gosu \
    && rm -rf /var/lib/apt/lists/*

# Instalar Docker CLI (solo cliente)
RUN DOCKER_VERSION=27.3.1 && \
    curl -fsSL "https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz" \
    | tar xz --strip-components=1 -C /usr/local/bin docker/docker

# Instalar Bun en /usr/local para que sea accesible por cualquier usuario
RUN BUN_INSTALL=/usr/local curl -fsSL https://bun.sh/install | bash
ENV PATH="/usr/local/bin:$PATH"

# Instalar Claude Code globalmente
RUN npm install -g @anthropic-ai/claude-code

# Crear usuario no-root (requerido por --dangerously-skip-permissions)
RUN useradd -m -u 1001 -s /bin/bash claude

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# El entrypoint corre como root para ajustar grupos, luego usa gosu para bajar a claude
WORKDIR /home/claude
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
