#!/bin/bash

clear
echo "====================================="
echo "      SKY PANEL V1 INSTALLER"
echo "====================================="

# Update system
sudo apt update && sudo apt upgrade -y

# Install required packages
sudo apt install -y git curl unzip python3 python3-pip npm

# Install Cloudflare Tunnel
echo ""
echo "[1/6] Installing Cloudflare Tunnel..."
curl -fsSL https://pkg.cloudflare.com/install.sh | sudo bash
sudo apt install cloudflared -y

echo ""
echo "========================================"
echo "LOGIN TO CLOUDFLARE"
echo "========================================"
echo "Run the following command:"
echo ""
echo "cloudflared tunnel login"
echo ""
echo "Complete the browser login, then press ENTER."
read

# Clone Panel
echo "[2/6] Cloning SKY PANEL V1..."
git clone https://github.com/SKYDO234/SKYPANELV1.git

cd SKYPANELV1 || exit

# Install Node modules
echo "[3/6] Installing Node.js packages..."
npm install

# Install Python requirements
echo "[4/6] Installing Python packages..."
pip3 install -r requirements.txt
python3 -m pip install --break-system-packages -r requirements.txt

# Create Tunnel
echo ""
echo "========================================"
echo "CREATE YOUR TUNNEL"
echo "========================================"
echo "Example:"
echo "cloudflared tunnel create skypanel"
echo ""
read -p "Enter your Tunnel Name: " TUNNEL

cloudflared tunnel create "$TUNNEL"

echo ""
echo "Now create a DNS route:"
echo ""
echo "cloudflared tunnel route dns $TUNNEL panel.yourdomain.com"
echo ""
echo "Replace panel.yourdomain.com with your own domain."
read -p "Press ENTER when done..."

# Run Panel
echo "[5/6] Starting SKY PANEL V1..."
python3 hvm.py &

echo ""
echo "========================================"
echo "START THE TUNNEL"
echo "========================================"
echo "Run:"
echo ""
echo "cloudflared tunnel --url http://localhost:5000 run $TUNNEL"
echo ""
echo "Replace port 5000 if your panel uses another port."

echo ""
echo "========================================"
echo "INSTALLATION COMPLETE!"
echo "========================================"
