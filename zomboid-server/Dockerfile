FROM ghcr.io/steamcmd/steamcmd:ubuntu-22

ARG RCON_CLI_VERSION=0.10.3
ENV ZOMBOID_SERVER_APP_ID=380870
ENV ZOMBOID_GAME_APP_ID=108600

ENV STEAM_WORKSHOP_DEFAULT_DIR=/root/.local/share/Steam/steamapps/workshop
ENV CACHE_DIR=/root/Zomboid

RUN apt-get update \
    && apt-get install -y --no-install-recommends python3 python3-pip python3-venv \
    && rm -rf /var/lib/apt/lists/*

ARG PZ_BETA_BRANCH=""
RUN mkdir -p /pzomboid-server \
    && steamcmd +login anonymous +quit \
    && steamcmd +force_install_dir /pzomboid-server \
    +login anonymous \
    +app_update ${ZOMBOID_SERVER_APP_ID} ${PZ_BETA_BRANCH:+-beta ${PZ_BETA_BRANCH}} validate \
    +quit

VOLUME ["${STEAM_WORKSHOP_DEFAULT_DIR}", "${CACHE_DIR}"]

COPY ./defaults /defaults
COPY ./scripts /scripts

RUN chmod -R a+x /scripts \
    && /scripts/build/install-admin-console.sh \
    && /scripts/build/find_build_id.sh > /PZ_BUILD_ID

ARG BUILD_DATE
ARG VCS_REF
ARG PZ_VERSION
ARG PZ_BUILD_ID
ARG DOCS=blob/main/README.md

LABEL org.opencontainers.image.created=${BUILD_DATE}
LABEL org.opencontainers.image.authors="Meshi Team <https://github.com/meshi-team>"
LABEL org.opencontainers.image.version=${PZ_VERSION}
LABEL org.opencontainers.image.revision=${VCS_REF}
LABEL org.opencontainers.image.title="Project Zomboid Dedicated Server"
LABEL org.opencontainers.image.url="https://github.com/meshi-team/project-zomboid-server"
LABEL org.opencontainers.image.documentation="https://github.com/meshi-team/project-zomboid-server/${DOCS}"
LABEL org.opencontainers.image.source="https://github.com/meshi-team/project-zomboid-server"
LABEL org.opencontainers.image.base.name="ghcr.io/steamcmd/steamcmd:ubuntu-22"
LABEL org.opencontainers.image.vendor="Meshi Team"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.description="Project Zomboid dedicated server (v${PZ_VERSION}) container image with persistent world storage, workshop mod support, and customizable configuration."
LABEL com.projectzomboid.version="${PZ_VERSION}"
LABEL com.projectzomboid.buildId="${PZ_BUILD_ID}"
LABEL com.projectzomboid.steamBranch="${PZ_BETA_BRANCH:-public}"
LABEL io.github.meshi-team.project-zomboid-server.maintainer="Meshi Team"
LABEL io.github.meshi-team.project-zomboid-server.is-production="true"

ENTRYPOINT ["bash", "/scripts/entrypoint.sh"]
CMD []
