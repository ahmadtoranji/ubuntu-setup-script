#!/bin/bash

set -e

echo "Starting installation process..."

# 1. Update and upgrade Ubuntu
echo "Updating and upgrading Ubuntu..."
sudo apt-get update -y
sudo apt-get upgrade -y

# 2. Install Docker
echo "Installing Docker..."
# Remove old Docker versions if they exist
sudo apt-get remove docker docker-engine docker.io containerd runc -y

# Install dependencies
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index and install Docker
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

# Enable and start Docker service
sudo systemctl enable docker
sudo systemctl start docker

# 3. Install Docker Compose
echo "Installing Docker Compose..."
DOCKER_COMPOSE_VERSION=$(curl --silent "https://api.github.com/repos/docker/compose/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')
sudo curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 4. Setup Docker Compose for Mikrotik RouterOS
echo "Setting up Docker Compose for Mikrotik RouterOS..."
cat <<EOF > docker-compose.yml
version: '3'
services:
  mikrotik-routeros:
    image: bailangwuren/routeros
    container_name: mikrotik-routeros
    ports:
      - "80:80"
      - "443:443"
      - "8291:8291"
    restart: unless-stopped
    privileged: true
EOF

# Start the Mikrotik RouterOS container
sudo docker-compose up -d

echo "Installation completed!"
