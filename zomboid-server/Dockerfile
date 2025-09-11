FROM ghcr.io/steamcmd/steamcmd:ubuntu-24

ARG RCON_CLI_VERSION=0.10.3
ENV ZOMBOID_SERVER_APP_ID=380870
ENV ZOMBOID_GAME_APP_ID=108600

ENV STEAM_WORKSHOP_DEFAULT_DIR=/root/.local/share/Steam/steamapps/workshop
ENV CACHE_DIR=/root/Zomboid

RUN apt-get update \
    && apt-get install -y --no-install-recommends python3 python3-pip python3-venv \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /pzomboid-server \
    && steamcmd +login anonymous \
    +force_install_dir /pzomboid-server \
    +app_update ${ZOMBOID_SERVER_APP_ID} validate \
    +quit

VOLUME ["${STEAM_WORKSHOP_DEFAULT_DIR}", "${CACHE_DIR}"]

COPY ./scripts /scripts

RUN chmod -R a+x /scripts \
    && /scripts/build/generate-defaults.sh \
    && /scripts/build/install-admin-console.sh

ENTRYPOINT ["bash", "/scripts/entrypoint.sh"]
