FROM ghcr.io/sillytavern/sillytavern:latest

# 1. Switch to Root to bypass all permission errors
USER root

# 2. Create the directories
RUN mkdir -p /home/node/app/config /home/node/app/data

# 3. Create entrypoint script that generates config.yaml before starting server
RUN echo '#!/bin/sh' > /entrypoint.sh && \
    echo 'cat > /home/node/app/config/config.yaml << EOF' >> /entrypoint.sh && \
    echo 'listen: true' >> /entrypoint.sh && \
    echo 'port: 8080' >> /entrypoint.sh && \
    echo 'whitelistMode: false' >> /entrypoint.sh && \
    echo 'basicAuthMode: true' >> /entrypoint.sh && \
    echo 'basicAuthUser:' >> /entrypoint.sh && \
    echo '  username: "${BASIC_USER:-admin}"' >> /entrypoint.sh && \
    echo '  password: "${BASIC_PASS:-changeme}"' >> /entrypoint.sh && \
    echo 'enableUserAccounts: false' >> /entrypoint.sh && \
    echo 'securityOverride: false' >> /entrypoint.sh && \
    echo 'autorun: false' >> /entrypoint.sh && \
    echo 'enableCorsProxy: false' >> /entrypoint.sh && \
    echo 'allowKeysExposure: false' >> /entrypoint.sh && \
    echo 'EOF' >> /entrypoint.sh && \
    echo 'exec node server.js --configPath /home/node/app/config/config.yaml --dataRoot /home/node/app/data' >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

# 4. Use entrypoint script
ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
