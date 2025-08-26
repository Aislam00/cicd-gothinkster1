#!/bin/bash

# SSH into Jenkins instance and configure it
ssh -i ~/.ssh/id_rsa ubuntu@18.130.120.140 << 'REMOTE_EOF'

# Install additional packages needed for the pipeline
sudo apt-get update
sudo apt-get install -y nodejs npm

# Install AWS CLI if not already installed
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Add Jenkins user to docker group
sudo usermod -aG docker jenkins

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Restart Jenkins to apply group changes
sudo systemctl restart jenkins

REMOTE_EOF
