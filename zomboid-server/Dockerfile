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

COPY ./scripts /scripts
COPY ./env /env

VOLUME [ "/root/Zomboid" ]

ARG RCON_CLI_VERSION=0.10.3
ENV RCON_CLI_DOWNLOAD_URL="https://github.com/gorcon/rcon-cli/releases/download/v${RCON_CLI_VERSION}/rcon-${RCON_CLI_VERSION}-amd64_linux.tar.gz"

# Install RCON CLI tool and setup admin console
RUN set -eux; \
    # Install dependencies
    apt-get update; \
    apt-get install -y --no-install-recommends wget; \
    \
    # Download and install RCON CLI
    wget "${RCON_CLI_DOWNLOAD_URL}" -O rcon.tar.gz; \
    tar -xzf rcon.tar.gz; \
    mv "rcon-${RCON_CLI_VERSION}-amd64_linux/rcon" /usr/local/bin/rcon; \
    \
    # Install admin console script
    mv /scripts/admin-console.sh /usr/local/bin/admin-console; \
    chmod +x /usr/local/bin/admin-console; \
    \
    # Make all scripts executable
    chmod +x /scripts/*.sh; \
    \
    # Cleanup
    rm -rf rcon.tar.gz "rcon-${RCON_CLI_VERSION}-amd64_linux"; \
    apt-get purge -y --auto-remove wget; \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["bash", "/scripts/entrypoint.sh"]
