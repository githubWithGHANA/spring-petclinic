#!/bin/bash
set -e

echo "Validating Spring Petclinic deployment..."

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/.."

if [ ! -f docker-compose.yml ]; then
    echo "ERROR: docker-compose.yml not found in $(pwd)"
    exit 1
fi

echo "Docker Compose status:"
docker compose ps

echo "Checking application..."

if curl -f http://localhost:8080/ > /dev/null 2>&1; then
    echo "Spring Petclinic is responding on port 8080."
else
    echo "ERROR: Spring Petclinic is not responding."
    echo "Container logs:"
    docker compose logs --tail=50
    exit 1
fi

echo "Validation successful."