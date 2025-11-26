#!/bin/bash
set -e

echo "=== SEOFlow Setup ==="

# DNS
echo 'nameserver 8.8.8.8' > /etc/resolv.conf
sleep 2

# Base packages
echo "Installing base packages..."
apt-get update
apt-get install -y openssh-server sudo curl git nano python3 python3-pip samba

# Node.js
echo "Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs

# Claude Code
echo "Installing Claude Code..."
npm install -g @anthropic-ai/claude-code

# User
echo "Creating user..."
useradd -m -s /bin/bash ${SEOFLOW_USER:-dev} || true
echo "${SEOFLOW_USER:-dev}:${SEOFLOW_PASS:-seoflow}" | chpasswd
echo "${SEOFLOW_USER:-dev} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Folders
mkdir -p /run/sshd /app/data /app/config /app/src
chown -R ${SEOFLOW_USER:-dev}:${SEOFLOW_USER:-dev} /app

echo "=== Setup Complete ==="

# Start SSH
exec /usr/sbin/sshd -D
