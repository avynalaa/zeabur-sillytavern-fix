FROM ghcr.io/sillytavern/sillytavern:latest

# 1. Create the directories
RUN mkdir -p /home/node/app/config /home/node/app/data

# 2. FORCE settings using Environment Variables
# This overrides whatever is in the config.yaml file
ENV SILLYTAVERN_PORT=8080
ENV SILLYTAVERN_WHITELISTMODE=false
ENV SILLYTAVERN_BASICAUTHMODE=true
ENV SILLYTAVERN_BASICAUTHUSER=avynala
ENV SILLYTAVERN_BASICAUTHPASSWORD=111

# 3. Start the server (pointing to your volumes)
CMD ["node", "server.js", "--configPath", "/home/node/app/config/config.yaml", "--dataRoot", "/home/node/app/data"]
