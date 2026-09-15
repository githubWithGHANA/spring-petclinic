#!/bin/bash

echo "Stopping Spring Petclinic..."

docker rm -f spring-petclinic 2>/dev/null || true

echo "Spring Petclinic stopped."
exit 0