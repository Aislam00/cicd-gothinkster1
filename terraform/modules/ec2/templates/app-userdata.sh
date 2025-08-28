#!/bin/bash
set -e

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y curl wget gnupg2 software-properties-common awscli jq

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu jammy stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

systemctl enable docker
systemctl start docker
usermod -aG docker ubuntu

sleep 30

aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin ${ecr_registry}

docker stop realworld-api || true
docker rm realworld-api || true

docker pull --platform linux/amd64 ${ecr_registry}/realworld-api:latest || echo "Image not found, will wait for deployment"

docker run -d \
    --name realworld-api \
    --restart always \
    -p 3000:3000 \
    -e NODE_ENV="production" \
    -e PORT="3000" \
    -e HOST="0.0.0.0" \
    ${ecr_registry}/realworld-api:latest || echo "Failed to start container - will retry on deployment"

sleep 60

curl -f http://localhost:3000/health && echo "Health check passed" || echo "Health check failed - container may not be running yet"

echo "User data script completed"
