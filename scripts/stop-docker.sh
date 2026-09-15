#!/bin/bash

echo "Stopping existing Spring Petclinic container..."

if docker ps -aq -f name=^spring-petclinic$ | grep -q .; then
    echo "Removing existing spring-petclinic container..."
    docker rm -f spring-petclinic
else
    echo "No existing spring-petclinic container found."
fi

echo "ApplicationStop completed successfully."

exit 0
