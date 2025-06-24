FROM ghcr.io/steamcmd/steamcmd:ubuntu-24

RUN mkdir -p /pzomboid-server

WORKDIR /pzomboid-server

COPY ./scripts ./scripts

ENTRYPOINT [ "sh", "./scripts/entrypoint.sh" ]
