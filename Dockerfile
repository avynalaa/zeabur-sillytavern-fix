FROM ghcr.io/sillytavern/sillytavern:latest

# 1. Create the directories so they exist before mounting
RUN mkdir -p /home/node/app/config /home/node/app/data

# 2. Force the container to use these writable folders
# We bake the arguments directly into the startup command
CMD ["node", "server.js", "--configPath", "/home/node/app/config/config.yaml", "--dataRoot", "/home/node/app/data", "--port", "8080"]
