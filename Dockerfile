FROM ghcr.io/sillytavern/sillytavern:latest

# 1. Switch to Root to bypass all permission errors
USER root

# 2. Create the directories
RUN mkdir -p /home/node/app/config /home/node/app/data

# 3. Start the server
# We rely on the Zeabur Environment Variables for the password/port settings
CMD ["node", "server.js", "--configPath", "/home/node/app/config/config.yaml", "--dataRoot", "/home/node/app/data"]
