#!/bin/bash
#
# admin-console.sh - Connects to the Project Zomboid server RCON console
#
# This script establishes a connection to the Project Zomboid server's RCON
# (Remote Console) interface for server administration. It loads the server
# environment variables and connects using the configured RCON settings.
#
# Prerequisites:
#   - rcon binary must be installed and available in PATH
#   - RCON must be enabled on the Project Zomboid server
#   - Valid RCON credentials must be configured
#
# Usage:
#   ./admin-console.sh [options]
#
# Environment Variables:
#   RCON_HOST     - RCON server hostname/IP (default: localhost)
#   RCON_PORT     - RCON server port (default: 27015)
#   RCON_PASSWORD - RCON authentication password (required)
#
# Examples:
#   ./admin-console.sh                    # Connect to localhost with env vars
#   RCON_HOST=192.168.1.100 ./admin-console.sh  # Connect to remote server

set -euo pipefail

# Get script directory for relative path resolution
SCRIPTS_DIR=/scripts
ENV_SCRIPT="${SCRIPTS_DIR}/load-env.sh"

# Source environment variables if available
if [[ -f "${ENV_SCRIPT}" ]]; then
	# shellcheck source=load-env.sh
	source "${ENV_SCRIPT}"
else
	echo "Warning: Environment script not found: ${ENV_SCRIPT}"
	echo "Using default/manual environment variables..."
fi

# Set default values for RCON connection
RCON_HOST="${RCON_HOST:-localhost}"
RCON_PORT="${RCON_PORT:-27015}"

echo "Connecting to Project Zomboid RCON console..."
echo "Host: ${RCON_HOST}"
echo "Port: ${RCON_PORT}"
echo "Password: [HIDDEN]"
echo ""
echo "Type :q or press Ctrl+C to exit the console"
echo "WARNING: If connection refused, please wait for the server to fully start."
echo "=========================================="

# Connect to RCON with proper error handling
# -a: address:port, -p: password
if ! rcon -a "${RCON_HOST}:${RCON_PORT}" -p "${RCON_PASSWORD}"; then
	echo ""
	echo "Error: Failed to connect to RCON server"
	echo "Please verify:"
	echo "  - Server is running and fully started"
	echo "  - Host (${RCON_HOST}) and port (${RCON_PORT}) are correct"
	echo "  - RCON password is correct"
	exit 1
fi
