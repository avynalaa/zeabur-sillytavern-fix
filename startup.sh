#!/bin/sh
set -e

echo "Generating config.yaml..."
cat > /home/node/app/config/config.yaml << EOF
listen: true
port: 8080
whitelistMode: false
basicAuthMode: true
basicAuthUser:
  username: "${BASIC_USER:-admin}"
  password: "${BASIC_PASS:-changeme}"
enableUserAccounts: false
securityOverride: false
autorun: false
enableCorsProxy: false
allowKeysExposure: false
EOF

echo "Config generated. Starting SillyTavern..."
exec node server.js --configPath /home/node/app/config/config.yaml --dataRoot /home/node/app/data
