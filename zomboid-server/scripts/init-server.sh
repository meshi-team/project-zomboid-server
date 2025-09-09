#!/bin/bash
# shellcheck disable=SC2154

# init-server.sh - Initializes the Project Zomboid server
#
# This script is executes the project-zomboid-server ./start-server.sh script
# to start the Project Zomboid server with the provided environment variables and
# flags.
#
# Usage:
#   ./init-server.sh

set -eo pipefail

START_SCRIPT="${SERVER_DIR}/start-server.sh"

declare -a ARGS=()

# JVM args
if [[ -n "${SERVER_MEMORY}" ]]; then
	ARGS+=("-Xmx${SERVER_MEMORY}" "-Xms${SERVER_MEMORY}")
fi
[[ "${SOFTRESET,,}" =~ ^(1|true)$ ]] && ARGS+=("-Dsoftreset")

ARGS+=("--")

# Server args
[[ -n "${MODFOLDERS}" ]] && ARGS+=("-modfolders" "${MODFOLDERS}")
[[ "${COOP_SERVER,,}" =~ ^(1|true)$ ]] && ARGS+=("-coop")
[[ "${NO_STEAM,,}" =~ ^(1|true)$ ]] && ARGS+=("-nosteam")
[[ -n "${CACHE_DIR}" ]] && ARGS+=("-cachedir=${CACHE_DIR}")
[[ "${DEBUG,,}" =~ ^(1|true)$ ]] && ARGS+=("-debug")
[[ -n "${ADMIN_USERNAME}" ]] && ARGS+=("-adminusername" "${ADMIN_USERNAME}")
[[ -n "${ADMIN_PASSWORD}" ]] && ARGS+=("-adminpassword" "${ADMIN_PASSWORD}")

if [[ -n "${SERVER_NAME}" ]]; then
	SERVER_NAME="${SERVER_NAME// /-}"
	ARGS+=("-servername" "${SERVER_NAME}")
fi

[[ -n "${IP}" ]] && ARGS+=("-ip" "${IP}")
[[ -n "${PORT}" ]] && ARGS+=("-port" "${PORT}")
[[ -n "${STEAM_VAC}" ]] && ARGS+=("-steamvac" "${STEAM_VAC,,}")
[[ -n "${STEAM_PORT_1}" ]] && ARGS+=("-steamport1" "${STEAM_PORT_1}")
[[ -n "${STEAM_PORT_2}" ]] && ARGS+=("-steamport2" "${STEAM_PORT_2}")

export LD_LIBRARY_PATH="${SERVER_DIR}/jre64/lib:${LD_LIBRARY_PATH:-}"
export LANG="${LANG:-en_US.UTF-8}"

echo "Starting Project Zomboid server with arguments: ${ARGS[*]}"
exec "${START_SCRIPT}" "${ARGS[@]}"
