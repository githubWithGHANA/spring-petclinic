#!/bin/bash
set -e

echo "Starting Spring Petclinic with Docker Compose..."

# Directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Go to the deployment root
cd "$SCRIPT_DIR/.."

echo "Working directory: $(pwd)"
echo "Checking Docker Compose file..."

if [ ! -f docker-compose.yml ]; then
    echo "ERROR: docker-compose.yml not found in $(pwd)"
    exit 1
fi

AWS_REGION=$(aws configure get region 2>/dev/null || true)

if [ -z "$AWS_REGION" ]; then
    TOKEN=$(curl -sX PUT \
      "http://169.254.169.254/latest/api/token" \
      -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

    AWS_REGION=$(curl -sH \
      "X-aws-ec2-metadata-token: $TOKEN" \
      http://169.254.169.254/latest/meta-data/placement/region)
fi

if [ -z "$AWS_REGION" ]; then
    AWS_REGION="ap-south-1"
fi

AWS_ACCOUNT_ID=$(aws sts get-caller-identity \
    --query Account \
    --output text)

ECR_REGISTRY="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"

IMAGE_NAME="spring-petclinic"
IMAGE_TAG="latest"

export ECR_REGISTRY

echo "Region: $AWS_REGION"
echo "Account: $AWS_ACCOUNT_ID"
echo "ECR image: $ECR_REGISTRY/$IMAGE_NAME:$IMAGE_TAG"

echo "Logging in to ECR..."

aws ecr get-login-password --region "$AWS_REGION" \
  | docker login \
      --username AWS \
      --password-stdin "$ECR_REGISTRY"

echo "Pulling latest image..."

docker compose pull

echo "Starting containers..."

docker compose up -d

echo "Current containers:"
docker compose ps

echo "Spring Petclinic started successfully."
