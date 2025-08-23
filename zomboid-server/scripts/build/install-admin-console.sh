#!/usr/bin/env bash

# install-admin-console.sh - Install RCON CLI and admin-console script
#
# This script installs the rcon CLI and the admin-console wrapper into the image.
# This allows the user to easily manage the Zomboid server via RCON protocol by just
# executing "admin-console" on the command line.
#
# This script is intended to be run at build time. It downloads RCON protocol binaries,
# installs them, and sets up the admin-console script.
#
# Environment variables
# - RCON_CLI_VERSION:       - Version of the rcon CLI to install
# - RCON_CLI_DOWNLOAD_URL:  - URL to download the rcon CLI
# - ADMIN_CONSOLE_SCRIPT:   - Path to the admin-console script
#

set -euo pipefail

echo "[install-admin-console] Installing rcon CLI and admin-console script"

# Defaults if not provided
RCON_CLI_VERSION="${RCON_CLI_VERSION:-0.10.3}"
RCON_CLI_DOWNLOAD_URL="${RCON_CLI_DOWNLOAD_URL:-https://github.com/gorcon/rcon-cli/releases/download/v${RCON_CLI_VERSION}/rcon-${RCON_CLI_VERSION}-amd64_linux.tar.gz}"
ADMIN_CONSOLE_SCRIPT="${ADMIN_CONSOLE_SCRIPT:-/scripts/build/admin-console.sh}"

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends wget ca-certificates

# Download and install rcon CLI
wget "${RCON_CLI_DOWNLOAD_URL}" -O /tmp/rcon.tar.gz
tar -xzf /tmp/rcon.tar.gz -C /tmp

# Find extracted rcon directory dynamically (e.g., rcon-0.10.3-amd64_linux)
RCON_DIR=$(find /tmp -maxdepth 1 -type d -name 'rcon-*-amd64_linux' | head -n 1)
if [[ -z "${RCON_DIR}" ]]; then
	echo "[install-admin-console] ERROR: Could not locate extracted rcon directory"
	exit 1
fi
mv "${RCON_DIR}/rcon" /usr/local/bin/rcon
chmod +x /usr/local/bin/rcon

# Install admin console script
mv "${ADMIN_CONSOLE_SCRIPT}" /usr/local/bin/admin-console
chmod +x /usr/local/bin/admin-console

# Cleanup
rm -rf /tmp/rcon.tar.gz "${RCON_DIR}"
apt-get purge -y --auto-remove wget
rm -rf /var/lib/apt/lists/*

echo "[install-admin-console] Done"
