#!/bin/bash
set -e

echo "Starting Spring Petclinic..."

AWS_REGION=$(aws configure get region)
if [ -z "$AWS_REGION" ]; then
    TOKEN=$(curl -sX PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
    AWS_REGION=$(curl -sH "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/region)
fi
if [ -z "$AWS_REGION" ]; then
    AWS_REGION="ap-south-1"
fi

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

ECR_REGISTRY="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"
IMAGE_NAME="spring-petclinic"
IMAGE_TAG="latest"

echo "Region: $AWS_REGION"
echo "Account: $AWS_ACCOUNT_ID"
echo "ECR image: $ECR_REGISTRY/$IMAGE_NAME:$IMAGE_TAG"

echo "Logging in to ECR..."
aws ecr get-login-password --region "$AWS_REGION" \
  | docker login --username AWS --password-stdin "$ECR_REGISTRY"

echo "Pulling latest image..."
docker pull "$ECR_REGISTRY/$IMAGE_NAME:$IMAGE_TAG"

echo "Starting container..."
docker run -d \
  --name spring-petclinic \
  --restart unless-stopped \
  -p 8080:8080 \
  "$ECR_REGISTRY/$IMAGE_NAME:$IMAGE_TAG"

echo "Spring Petclinic container started."
