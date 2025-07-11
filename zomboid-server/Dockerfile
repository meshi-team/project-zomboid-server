FROM ghcr.io/steamcmd/steamcmd:ubuntu-24 AS build

ENV ZOMBOID_APP_ID=380870

RUN mkdir -p /pzomboid-server \
    && steamcmd +login anonymous \
    +force_install_dir /pzomboid-server \
    +app_update ${ZOMBOID_APP_ID} validate \
    +quit

COPY ./scripts/build /scripts/build

RUN chmod +x /scripts/build/*.sh \
    && /scripts/build/generate-templates.sh

FROM python:3.12-slim AS runtime

COPY --from=build /pzomboid-server /pzomboid-server
COPY --from=build /root/Zomboid /root/Zomboid

VOLUME ["/pzomboid-server", "/root/Zomboid"]

COPY ./scripts /scripts
COPY ./env /env

VOLUME [ "/root/Zomboid" ]

RUN chmod +x /scripts/*.sh

ENTRYPOINT ["bash", "/scripts/entrypoint.sh"]
