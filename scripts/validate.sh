#!/bin/bash
set -e

echo "Waiting for Spring Petclinic to start..."

for i in {1..30}; do
    if curl -f http://localhost:8080/ >/dev/null 2>&1; then
        echo "Spring Petclinic is running successfully."
        exit 0
    fi
    echo "Application not ready yet... attempt $i/30"
    sleep 2
done

echo "Application failed to start."
docker logs spring-petclinic
exit 1
