#!/bin/bash
set -e

echo "Stopping Spring Petclinic..."

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/.."

if [ ! -f docker-compose.yml ]; then
    echo "ERROR: docker-compose.yml not found in $(pwd)"
    exit 1
fi

docker compose down

echo "Spring Petclinic stopped."