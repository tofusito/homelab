# Dockerfile for gluetun-custom
# Based on the official qmcgaw/gluetun image with added Python3 and curl

FROM qmcgaw/gluetun:latest

# Install Python3 and curl for custom scripts
RUN apk add --no-cache python3 curl

# Copy the port forwarding script
COPY forward_port_torrent.py /gluetun/forward_port_torrent.py

# Copy servers.json if needed (optional, gluetun has its own)
# COPY servers.json /gluetun/servers.json

# Set proper permissions
RUN chmod +x /gluetun/forward_port_torrent.py

# The rest inherits from the base gluetun image:
# - ENTRYPOINT ["/gluetun-entrypoint"]
# - EXPOSE 8000/tcp 8388/tcp 8388/udp 8888/tcp
# - All environment variables and configuration
