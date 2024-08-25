#!/bin/bash

# 1. به روز رسانی و ارتقاء مخازن اوبونتو
echo "Updating and upgrading Ubuntu..."
sudo apt-get update -y && sudo apt-get upgrade -y

# 2. نصب Docker
echo "Installing Docker..."
# حذف نسخه‌های قبلی Docker (در صورت وجود)
sudo apt-get remove docker docker-engine docker.io containerd runc -y
# نصب وابستگی‌ها
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y
# اضافه کردن کلید GPG برای Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
# اضافه کردن مخزن Docker به مخازن اوبونتو
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# به روز رسانی مخازن و نصب Docker
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
# فعال‌سازی و شروع به کار Docker
sudo systemctl enable docker
sudo systemctl start docker

# 3. نصب Mikrotik
echo "https://dl.dvx.ir/m.npk"
# دانلود آخرین نسخه Mikrotik از سایت رسمی (این خط باید بر اساس لینک دانلود مورد نظر شما تنظیم شود)
wget https://dl.dvx.ir/m.npk
# نصب Mikrotik
# این مرحله بستگی به نصب دقیق Mikrotik روی اوبونتو دارد، معمولاً از طریق Virtualization یا Containerization انجام می‌شود.
# به عنوان مثال، می‌توانید از Docker برای نصب یک کانتینر Mikrotik استفاده کنید یا نصب مستقیم در سرور فیزیکی را انجام دهید.

echo "Installation completed!"
