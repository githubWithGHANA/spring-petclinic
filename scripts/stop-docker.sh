#!/bin/bash
set -e

echo "Stopping Spring Petclinic..."

docker compose down

echo "Spring Petclinic stopped."