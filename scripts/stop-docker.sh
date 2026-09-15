#!/bin/bash

echo "Stopping Spring Petclinic..."

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEPLOY_DIR="$SCRIPT_DIR/.."

if [ ! -f "$DEPLOY_DIR/docker-compose.yml" ]; then
    echo "docker-compose.yml not found."
    echo "Nothing to stop. Continuing deployment..."
    exit 0
fi

cd "$DEPLOY_DIR"

echo "Using Compose file: $DEPLOY_DIR/docker-compose.yml"

docker compose down || {
    echo "Docker Compose down failed."
    exit 1
}

echo "Spring Petclinic stopped."