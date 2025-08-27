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

DB_SECRET=$(aws secretsmanager get-secret-value --secret-id "/${project_name}/${environment}/database" --region eu-west-2 --query SecretString --output text)
JWT_SECRET=$(aws secretsmanager get-secret-value --secret-id "/${project_name}/${environment}/jwt" --region eu-west-2 --query SecretString --output text)

DATABASE_URL=$(echo $DB_SECRET | jq -r .url)
JWT_SECRET_VALUE=$(echo $JWT_SECRET | jq -r .secret)

aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 475641479654.dkr.ecr.eu-west-2.amazonaws.com

docker pull --platform linux/amd64 475641479654.dkr.ecr.eu-west-2.amazonaws.com/realworld-api:latest

mkdir -p /opt/app

docker run -d \
    --name realworld-api \
    --restart always \
    -p 3000:3000 \
    -e DATABASE_URL="$DATABASE_URL" \
    -e JWT_SECRET="$JWT_SECRET_VALUE" \
    -e NODE_ENV="production" \
    -e PORT="3000" \
    -e HOST="0.0.0.0" \
    475641479654.dkr.ecr.eu-west-2.amazonaws.com/realworld-api:latest

sleep 90

curl -f http://localhost:3000/health && echo "Health check passed" || echo "Health check failed"

echo "User data script completed with RDS database"
