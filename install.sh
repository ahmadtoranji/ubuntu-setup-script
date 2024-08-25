#!/bin/bash

# 1. به روز رسانی و ارتقاء مخازن اوبونتو
echo "Updating and upgrading Ubuntu..."
sudo apt-get update -y && sudo apt-get upgrade -y

# 2. نصب Docker و وابستگی‌های لازم
echo "Installing Docker..."
# حذف نسخه‌های قدیمی Docker (در صورت وجود)
sudo apt-get remove docker docker-engine docker.io containerd runc -y

# نصب وابستگی‌ها
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y

# اضافه کردن کلید GPG برای Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# اضافه کردن مخزن Docker به منابع اوبونتو
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# به روز رسانی مخازن و نصب Docker
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

# فعال‌سازی و شروع به کار Docker
sudo systemctl enable docker
sudo systemctl start docker

# 3. نصب Mikrotik RouterOS از طریق Docker
echo "Pulling and running Mikrotik RouterOS Docker image..."
docker run -d --name mikrotik-routeros --restart unless-stopped --privileged mikrotik/routeros

echo "Installation completed!"
