FROM ghcr.io/sillytavern/sillytavern:latest

# 1. Create directories and FIX PERMISSIONS (Crucial!)
# We switch to root to make the folders, then give them to the 'node' user
USER root
RUN mkdir -p /home/node/app/config /home/node/app/data && \
    chown -R node:node /home/node/app/config /home/node/app/data

# 2. Switch back to the safe user
USER node

# 3. Start the server
CMD ["node", "server.js", "--configPath", "/home/node/app/config/config.yaml", "--dataRoot", "/home/node/app/data"]
