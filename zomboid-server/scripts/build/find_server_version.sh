#!/usr/bin/env bash

# find_server_version.sh - Build-time Project Zomboid version extractor
#
# Minimal script used ONLY during Docker build. It reads the server console log
# located at ${CACHE_DIR:-/root/Zomboid}/server-console.txt, finds the first
# occurrence of the token: version=XX(.YY)* and prints ONLY the numeric version
# to STDOUT. No exporting, no sourcing semantics—just plain output so the
# Dockerfile can capture it and persist it (e.g. into a file layer).
#
# Exit codes:
#   0  success
#   1  log file missing
#   2  version pattern not found

set -euo pipefail

CACHE_DIR="${CACHE_DIR:-/root/Zomboid}"
LOG_FILE="${CACHE_DIR}/server-console.txt"

if [[ ! -f "${LOG_FILE}" ]]; then
	echo "Error: log file not found: ${LOG_FILE}" >&2
	exit 1
fi

# Extract the first occurrence of version=... capturing only the value
if ! VERSION_LINE=$(grep -m1 -E 'version=[0-9]+(\.[0-9]+)*' "${LOG_FILE}" || true); then
	VERSION_LINE=""
fi

if [[ -z "${VERSION_LINE}" ]]; then
	echo "Error: version pattern not found in log file" >&2
	exit 2
fi

# Use parameter expansion to isolate the version token
VERSION_PART=${VERSION_LINE#*version=}
PROJECT_ZOMBOID_VERSION=${VERSION_PART%% *}

echo -n "${PROJECT_ZOMBOID_VERSION}"
