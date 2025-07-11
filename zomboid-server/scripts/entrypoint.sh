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

# Source environment variables
if [[ -f "${ENV_SCRIPT}" ]]; then
	# shellcheck source=load-env.sh
	source "${ENV_SCRIPT}"
else
	echo "Error: Environment script not found: ${ENV_SCRIPT}"
	exit 1
fi

if [[ ! -x "${SERVER_INIT_SCRIPT}" ]]; then
	echo "Error: Server initialization script not found or not executable: ${SERVER_INIT_SCRIPT}"
	exit 1
fi

if [[ $# -eq 0 ]]; then
	exec "${SERVER_INIT_SCRIPT}"
fi

exec "$@"
