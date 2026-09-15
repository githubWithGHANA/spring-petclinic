#!/bin/bash
set -e

echo "Validating Spring Petclinic deployment..."

if ! docker compose ps; then
    echo "Docker Compose is not running."
    exit 1
fi

if ! docker compose ps | grep -q "Up"; then
    echo "Containers are not running."
    docker compose ps
    exit 1
fi

echo "Containers are running."

if curl -f http://localhost:8080/ > /dev/null 2>&1; then
    echo "Spring Petclinic is responding on port 8080."
else
    echo "Spring Petclinic is not responding on port 8080."
    docker compose logs --tail=50
    exit 1
fi

echo "Validation successful."