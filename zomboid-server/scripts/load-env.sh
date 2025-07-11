#!/bin/bash

# load-env.sh - Loads environment variables from the /env scripts
#
# This script loads all the environment variables present at:
# - /env/server-init-flags.sh
# - /env/server-init-settings.sh
# - /env/server-sandbox-vars.sh
#
# It is intended to be sourced by other scripts to ensure that the environment
# variables are available for use in the Project Zomboid server configuration.

ENV_DIR="/env"

if [[ -f "${ENV_DIR}/server-init-flags.sh" ]]; then
	# shellcheck source=SCRIPTDIR/../env/server-init-flags.sh
	. "${ENV_DIR}/server-init-flags.sh"
	echo "Loaded ${ENV_DIR}/server-init-flags.sh"
else
	echo "Warning: ${ENV_DIR}/server-init-flags.sh not found, skipping."
fi

if [[ -f "${ENV_DIR}/server-init-settings.sh" ]]; then
	# shellcheck source=SCRIPTDIR/../env/server-init-settings.sh
	. "${ENV_DIR}/server-init-settings.sh"
	echo "Loaded ${ENV_DIR}/server-init-settings.sh"
else
	echo "Warning: ${ENV_DIR}/server-init-settings.sh not found, skipping."
fi

if [[ -f "${ENV_DIR}/server-sandbox-vars.sh" ]]; then
	# shellcheck source=SCRIPTDIR/../env/server-sandbox-vars.sh
	. "${ENV_DIR}/server-sandbox-vars.sh"
	echo "Loaded ${ENV_DIR}/server-sandbox-vars.sh"
else
	echo "Warning: ${ENV_DIR}/server-sandbox-vars.sh not found, skipping."
fi
