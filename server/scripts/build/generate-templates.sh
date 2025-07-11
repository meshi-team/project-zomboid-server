#!/usr/bin/env bash

# generate-templates.sh - Generates the template files Project Zomboid configuration
#
# This script starts the Project Zomboid server in the background to generate the
# template configuration files, specifically the template_SandboxVars.lua file and
# template.ini file.
#
# It waits for up to 120 seconds for the file to be created, then stops the server.
# If the file is not created within the timeout, it exits with an error.
#
# Usage:
#   ./generate-templates.sh
#

SERVER_DIR="${SERVER_DIR:-/pzomboid-server}"
CACHE_DIR="${CACHE_DIR:-/root/Zomboid}"
SECONDS=0

set -euo pipefail

cd "${SERVER_DIR}" || {
	echo "Error: Could not change to server directory: ${SERVER_DIR}"
	exit 1
}

chmod +x ./start-server.sh

echo "Starting server in background to generate template_SandboxVars.lua..."
./start-server.sh \
	-servername template \
	-adminpassword template \
	-cachedir="${CACHE_DIR}" &
server_pid=$!

echo "Waiting up to 120 seconds for file: ${CACHE_DIR}/Server/template_SandboxVars.lua"
start_time=${SECONDS}
while [[ $((SECONDS - start_time)) -lt 120 ]]; do
	if [[ -f "${CACHE_DIR}/Server/template_SandboxVars.lua" ]]; then
		break
	fi
	sleep 1
done

if [[ ! -f "${CACHE_DIR}/Server/template_SandboxVars.lua" ]]; then
	echo "Error: timed out after 120 seconds waiting for template_SandboxVars.lua"
	kill "${server_pid}" || true
	exit 1
fi

echo "File generated. Stopping server (PID: ${server_pid})..."
kill "${server_pid}" || true

echo "Done."
