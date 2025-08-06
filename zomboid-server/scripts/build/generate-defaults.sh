#!/usr/bin/env bash

# generate-defaults.sh - Generates the default files Project Zomboid configuration
#
# This script starts the Project Zomboid server in the background to generate the
# default configuration files, specifically the servertest_SandboxVars.lua file and
# servertest.ini file.
#
# It waits for up to 120 seconds for the file to be created, then stops the server.
# If the file is not created within the timeout, it exits with an error.
#
# The generated files are copied to /defaults/default_SandboxVars.lua and
# /defaults/default.ini.
#
# Usage:
#   ./generate-defaults.sh
#

SERVER_DIR="${SERVER_DIR:-/pzomboid-server}"
CACHE_DIR="${CACHE_DIR:-/root/Zomboid}"
DEFAULTS_DIR="${DEFAULTS_DIR:-/defaults}"
SECONDS=0

set -euo pipefail

cd "${SERVER_DIR}" || {
	echo "Error: Could not change to server directory: ${SERVER_DIR}"
	exit 1
}

chmod +x ./start-server.sh

echo "Starting server in background to generate servertest_SandboxVars.lua..."
./start-server.sh \
	-servername servertest \
	-adminpassword default \
	-cachedir="${CACHE_DIR}" &
server_pid=$!

echo "Waiting up to 120 seconds for file: ${CACHE_DIR}/Server/servertest_SandboxVars.lua"
start_time=${SECONDS}
while [[ $((SECONDS - start_time)) -lt 120 ]]; do
	if [[ -f "${CACHE_DIR}/Server/servertest_SandboxVars.lua" ]]; then
		break
	fi
	sleep 1
done

if [[ ! -f "${CACHE_DIR}/Server/servertest_SandboxVars.lua" ]]; then
	echo "Error: timed out after 120 seconds waiting for servertest_SandboxVars.lua"
	kill "${server_pid}" || true
	exit 1
fi

echo "Moving generated config files to ${DEFAULTS_DIR}..."
mkdir -p "${DEFAULTS_DIR}"
mv -f "${CACHE_DIR}/Server/servertest_SandboxVars.lua" "${DEFAULTS_DIR}/default_SandboxVars.lua"
mv -f "${CACHE_DIR}/Server/servertest.ini" "${DEFAULTS_DIR}/default.ini"

echo "File generated. Stopping server (PID: ${server_pid})..."
kill "${server_pid}" || true

echo "Done."
