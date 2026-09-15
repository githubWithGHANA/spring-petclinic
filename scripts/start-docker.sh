#!/bin/bash
set -e

echo "Starting Spring Petclinic with Docker Compose..."

export ECR_REGISTRY

docker compose pull
docker compose up -d

echo "Spring Petclinic started."