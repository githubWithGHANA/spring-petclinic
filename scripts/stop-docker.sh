#!/bin/bash
set -e

echo "Stopping existing Spring Petclinic container..."

if docker ps -q -f name=spring-petclinic | grep -q .; then
    docker stop spring-petclinic
fi

if docker ps -aq -f name=spring-petclinic | grep -q .; then
    docker rm spring-petclinic
fi

echo "Old container removed."
