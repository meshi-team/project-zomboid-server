FROM ghcr.io/steamcmd/steamcmd:ubuntu-24 AS build

ENV ZOMBOID_APP_ID=380870

RUN mkdir -p /pzomboid-server \
    && steamcmd +login anonymous \
    +force_install_dir /pzomboid-server \
    +app_update ${ZOMBOID_APP_ID} validate \
    +quit

COPY ./scripts/build /scripts/build

RUN chmod +x /scripts/build/*.sh \
    && /scripts/build/generate-defaults.sh

FROM python:3.12-slim AS runtime

COPY --from=build /pzomboid-server /pzomboid-server
COPY --from=build /root/Zomboid /zomboid-data
COPY --from=build /defaults /defaults

COPY ./scripts /scripts

ARG RCON_CLI_VERSION=0.10.3

RUN bash /scripts/build/install-admin-console.sh \
    && chmod +x /scripts/*.sh

ENTRYPOINT ["bash", "/scripts/entrypoint.sh"]
