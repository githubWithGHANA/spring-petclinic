#!/bin/bash

echo "Stopping Spring Petclinic..."

# Stop/remove the old application container if it exists.
if docker ps -a --format '{{.Names}}' | grep -q '^spring-petclinic$'; then
    echo "Removing old spring-petclinic container..."
    docker rm -f spring-petclinic
else
    echo "No spring-petclinic container found."
fi

echo "ApplicationStop completed successfully."
exit 0
