FROM ghcr.io/sillytavern/sillytavern:latest

USER root

RUN mkdir -p /home/node/app/config /home/node/app/data

COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

ENTRYPOINT ["/startup.sh"]
