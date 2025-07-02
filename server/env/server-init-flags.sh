#!/bin/bash

# ---- General settings ---- 
export SERVER_DIR="${SERVER_DIR:-/pzomboid-server}"
export PRESETS_DIR="${PRESETS_DIR:-${SERVER_DIR}/media/lua/shared/Sandbox}"
export ZOMBOID_APP_ID="${ZOMBOID_APP_ID:-380870}"

# ---- Java arguments ----
export MEMORY="${MEMORY:-2048m}"
export SOFTRESET="${SOFTRESET:-1}" # 0 = False, 1 = True

# ---- Server arguments ----
export COOP_SERVER="${COOP_SERVER:-0}" # 0 = False, 1 = True
export NO_STEAM="${NO_STEAM:-0}" # 0 = False, 1 = True
export CACHE_DIR="${CACHE_DIR:-~/Zomboid/Server}"
export DEBUG="${DEBUG:-0}" # 0 = False, 1 = True
export ADMIN_USERNAME="${ADMIN_USERNAME:-admin}"
export ADMIN_PASSWORD="${ADMIN_PASSWORD:-admin}"
export SERVER_NAME="${SERVER_NAME:-project-zomboid-server}"
export IP="${IP:-0.0.0.0}"
export PORT="${PORT:-16261}"
export STEAM_VAC="${STEAM_VAC:-0}" # 0 = False, 1 = True
export STEAM_PORT_1="${STEAM_PORT_1:-8766}"
export STEAM_PORT_2="${STEAM_PORT_2:-8767}"
