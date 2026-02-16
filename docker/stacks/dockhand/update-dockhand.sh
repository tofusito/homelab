#!/bin/bash

# Script to update Dockhand
# Usage: ./update-dockhand.sh

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="$SCRIPT_DIR/docker-dockerhand.yaml"

echo "🚀 Updating Dockhand..."
echo ""

# Navigate to script directory
cd "$SCRIPT_DIR"

# 1. Pull the latest image
echo "📥 Pulling latest Dockhand image..."
docker pull fnsys/dockhand:latest

# 2. Stop and remove current container
echo "🛑 Stopping current container..."
docker compose -f "$COMPOSE_FILE" down dockhand

# 3. Recreate container with new image
echo "🔄 Recreating container..."
docker compose -f "$COMPOSE_FILE" up -d dockhand

# 4. Wait for it to be ready
echo "⏳ Waiting for Dockhand to be ready..."
sleep 5

# 5. Verify status
echo ""
echo "✅ Dockhand updated successfully:"
docker ps --filter "name=dockhand" --format "   Container: {{.Names}}\n   Status: {{.Status}}\n   Image: {{.Image}}"

echo ""
echo "🌐 Access Dockhand at: http://localhost:3001"
