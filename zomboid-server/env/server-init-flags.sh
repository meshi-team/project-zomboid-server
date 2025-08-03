#!/bin/bash
# Project Zomboid Server Argument Flags
#
# This script defines default environment variables for the Project Zomboid
# dedicated server startup script (start-server.sh). These variables can
# be overridden at runtime to customize server behavior when running in Docker
# or other containerized environments.
#
# Usage:
#   Source this file before running start-server.sh:
#   source ./server-init-flags.sh
#   ./start-server.sh
#
# Docker Usage:
#   Override any variable using Docker's -e flag:
#   docker run -e SERVER_NAME="MyServer" -e PORT="16262" <image>

# Enable automatic export of all variables
set -a

# General server configuration
SERVER_DIR="${SERVER_DIR:-/pzomboid-server}"
PRESETS_DIR="${PRESETS_DIR:-${SERVER_DIR}/media/lua/shared/Sandbox}"
ZOMBOID_APP_ID="${ZOMBOID_APP_ID:-380870}"
SERVER_PRESET="${SERVER_PRESET:-}"
DEFAULTS_DIR="${DEFAULTS_DIR:-/defaults}"

# Java and memory settings
SERVER_MEMORY="${SERVER_MEMORY:-2048m}"
SOFTRESET="${SOFTRESET:-0}" # 0 = False, 1 = True

# Server behavior flags
SERVER_NAME="${SERVER_NAME:-servertest}"
COOP_SERVER="${COOP_SERVER:-0}" # 0 = False, 1 = True
NO_STEAM="${NO_STEAM:-0}"       # 0 = False, 1 = True
CACHE_DIR="${CACHE_DIR:-/root/Zomboid}"
DEBUG="${DEBUG:-0}" # 0 = False, 1 = True
ADMIN_USERNAME="${ADMIN_USERNAME:-admin}"
ADMIN_PASSWORD="${ADMIN_PASSWORD:-admin}"
IP="${IP:-0.0.0.0}"
PORT="${PORT:-16261}"
STEAM_VAC="${STEAM_VAC:-true}"
STEAM_PORT_1="${STEAM_PORT_1:-}"
STEAM_PORT_2="${STEAM_PORT_2:-}"

# Disable automatic export
set +a
