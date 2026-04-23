#!/usr/bin/env bash

# generate-defaults.sh - Dev utility to regenerate zomboid-server/defaults/.
# Not invoked at build time. Run inside a built container when bumping PZ.

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

shopt -s nullglob
for src in "${CACHE_DIR}/Server"/servertest*; do
	if [[ -f "${src}" ]]; then
		base="$(basename "${src}")"
		dest_suffix="${base#servertest}"
		dest="${DEFAULTS_DIR}/default${dest_suffix}"
		echo "  - ${base} -> $(basename "${dest}")"
		mv -f -- "${src}" "${dest}"
	fi
done
shopt -u nullglob

echo "File generated. Stopping server (PID: ${server_pid})..."
kill "${server_pid}" || true

echo "Done."
