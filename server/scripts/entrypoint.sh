#!/bin/bash

# Install the Project Zomboid server files
# Use the anonymous login to avoid needing a Steam account
steamcmd \
    +login anonymous \
    +force_install_dir $SERVER_DIR \
    +app_update $ZOMBOID_APP_ID validate \
    +quit

cd $SERVER_DIR

# Generate the server configuration files
# This will create the necessary directories and files
# by starting the server with as a template configuration
# It waits for 10 seconds to ensure the files are created
chmod +x ./start-server.sh && \
    ./start-server.sh -servername template -adminpassword template -cachedir=$CACHE_DIR & \
    sleep 10 && \
    pkill -f start-server.sh
