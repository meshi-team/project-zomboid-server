FROM ghcr.io/steamcmd/steamcmd:ubuntu-24 as Build

ENV SERVER_DIR=/pzomboid-server
ENV ZOMBOID_APP_ID=380870

RUN mkdir -p ${SERVER_DIR}

FROM python:3.12-slim as Runtime

COPY --from=Build /pzomboid-server /pzomboid-server
COPY --from=Build /scripts /scripts

ENTRYPOINT ["/bin/bash", "/scripts/entrypoint.sh"]
