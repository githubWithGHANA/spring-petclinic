#!/bin/bash
set -e

echo "Checking application..."

# Go to deployment root
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/.."

# Get AWS region
AWS_REGION=$(aws configure get region 2>/dev/null || true)

if [ -z "$AWS_REGION" ]; then
    AWS_REGION="ap-south-1"
fi

# Get AWS account
AWS_ACCOUNT_ID=$(aws sts get-caller-identity \
    --query Account \
    --output text)

# Set ECR registry
export ECR_REGISTRY="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"

echo "ECR registry: $ECR_REGISTRY"

# Wait for Spring Boot
MAX_RETRIES=30
RETRY=1

while [ $RETRY -le $MAX_RETRIES ]; do

    echo "Checking application... attempt $RETRY/$MAX_RETRIES"

    if curl -fs http://localhost:8080/ > /dev/null 2>&1; then
        echo "Spring Petclinic is responding."
        exit 0
    fi

    sleep 5
    RETRY=$((RETRY + 1))
done

echo "ERROR: Spring Petclinic is not responding."
echo "Container status:"
docker compose ps

echo "Container logs:"
docker compose logs --tail=100

exit 1
