#!/bin/bash

# Grafana Monitoring Stack Setup Script
# This script helps you configure the monitoring stack with Traefik

set -e

echo "🚀 Grafana Monitoring Stack Setup"
echo "=================================="
echo ""

# Check if .env exists
if [ -f .env ]; then
    echo "⚠️  .env file already exists!"
    read -p "Do you want to overwrite it? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Setup cancelled."
        exit 0
    fi
fi

# Prompt for domain
echo ""
echo "📝 Configuration"
echo "---------------"
read -p "Enter your Grafana domain (e.g., grafana.yourdomain.com): " GRAFANA_DOMAIN

if [ -z "$GRAFANA_DOMAIN" ]; then
    echo "❌ Domain cannot be empty!"
    exit 1
fi

# Create .env file
cat > .env << EOF
# Grafana Domain Configuration
GRAFANA_DOMAIN=$GRAFANA_DOMAIN
EOF

echo ""
echo "✅ Configuration saved to .env"
echo ""

# Check if traefik-public network exists
if docker network inspect traefik-public >/dev/null 2>&1; then
    echo "✅ traefik-public network already exists"
else
    echo "📡 Creating traefik-public network..."
    docker network create traefik-public
    echo "✅ traefik-public network created"
fi

echo ""
echo "🎯 Next Steps:"
echo "-------------"
echo "1. Ensure your DNS A record points $GRAFANA_DOMAIN to this server"
echo "2. Make sure Traefik is running: cd /root/traefik && docker compose ps"
echo "3. Start the monitoring stack: docker compose up -d"
echo "4. Access Grafana at: https://$GRAFANA_DOMAIN"
echo ""
echo "Default credentials: admin / admin"
echo "⚠️  Remember to change the password on first login!"
echo ""
