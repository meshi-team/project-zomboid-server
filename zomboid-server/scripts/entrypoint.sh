#!/bin/bash
#
# entrypoint.sh - Entrypoint script for the Project Zomboid server Docker container
#
# This script serves as the main entrypoint for the Docker container.
# It loads server environment variables for Docker-based customization,
# replaces configuration files with environment-specific values,
# and starts the Project Zomboid server using the final configuration.

DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
ENV_SCRIPT="${DIR}/load-env.sh"
SERVER_INIT_SCRIPT="${DIR}/init-server.sh"
SERVER_CONFIG_UPDATE_SCRIPT="${DIR}/setup/update_server_config.py"

# Source environment variables
if [[ -f "${ENV_SCRIPT}" ]]; then
	# shellcheck source=load-env.sh
	source "${ENV_SCRIPT}"
else
	echo "Error: Environment script not found: ${ENV_SCRIPT}"
	exit 1
fi

mkdir -p "${CACHE_DIR}"
HAS_CONTENTS=$(ls -A "${CACHE_DIR}" 2>/dev/null || true)
if [[ -z "${HAS_CONTENTS}" ]]; then
	cp -r /zomboid-data/. "${CACHE_DIR}/"
fi

chmod -R 777 "${CACHE_DIR}"

# Update server configuration for custom settings
if [[ -f "${SERVER_CONFIG_UPDATE_SCRIPT}" ]]; then
	(cd "${DIR}/setup" && python3 update_server_config.py)
else
	echo "Warning: Server configuration update script not found: ${SERVER_CONFIG_UPDATE_SCRIPT}"
	exit 1
fi

if [[ ! -x "${SERVER_INIT_SCRIPT}" ]]; then
	echo "Error: Server initialization script not found or not executable: ${SERVER_INIT_SCRIPT}"
	exit 1
fi

echo "Server configuration has been updated. Continuing in 5 seconds..."
sleep 5

# Execute the server initialization script
# If no arguments are provided, run the server as default
if [[ $# -eq 0 ]]; then
	exec "${SERVER_INIT_SCRIPT}"
fi

# Excecute the Command passed to the container
exec "$@"
