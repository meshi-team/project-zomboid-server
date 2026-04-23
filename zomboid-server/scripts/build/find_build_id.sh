#!/usr/bin/env bash

# find_build_id.sh - Extract the Steam buildid from the server's appmanifest
# and print it to STDOUT so the Dockerfile can persist it into /PZ_BUILD_ID.
#
# Exit codes:
#   0  success
#   1  appmanifest file missing
#   2  buildid not found

set -euo pipefail

SERVER_DIR="${SERVER_DIR:-/pzomboid-server}"
APP_ID="${ZOMBOID_SERVER_APP_ID:-380870}"
MANIFEST="${SERVER_DIR}/steamapps/appmanifest_${APP_ID}.acf"

if [[ ! -f "${MANIFEST}" ]]; then
	echo "Error: appmanifest not found: ${MANIFEST}" >&2
	exit 1
fi

BUILD_ID=$(awk -F'"' '/"buildid"/ {print $4; exit}' "${MANIFEST}")

if [[ -z "${BUILD_ID}" ]]; then
	echo "Error: buildid not found in ${MANIFEST}" >&2
	exit 2
fi

echo -n "${BUILD_ID}"
