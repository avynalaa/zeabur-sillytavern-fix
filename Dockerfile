FROM ghcr.io/sillytavern/sillytavern:latest

# 1. Create the directories
RUN mkdir -p /home/node/app/config /home/node/app/data

# 2. Start the server (pointing to your volumes)
CMD ["node", "server.js", "--configPath", "/home/node/app/config/config.yaml", "--dataRoot", "/home/node/app/data"]
