#!/bin/bash
# Project Zomboid Server Configuration Settings
#
# This script defines default environment variables for Project Zomboid
# server configuration settings that correspond to the <server-name>.ini file.
# These variables control general server behavior, gameplay mechanics, PvP settings,
# anti-cheat protection, and various multiplayer features.
#
# These environment variables can be overridden at runtime to customize
# server configuration when running in Docker or other containerized environments.
# Each variable uses the bash parameter expansion syntax ${VAR:-default} to
# provide fallback values if not explicitly set.
#
# Usage:
#   Source this file before generating server configuration:
#   source ./server-init-settings.sh
#
# Docker Usage:
#   Override any variable using Docker's -e flag:
#   docker run -e PVP="false" -e MAX_PLAYERS="64" -e PUBLIC="true" <image>
#
# Configuration Categories:
#   - Basic server settings (PVP, player limits, ports)
#   - Chat and communication (global chat, voice settings)
#   - Gameplay mechanics (spawn points, safety system, loot respawn)
#   - Safehouse and faction management
#   - Admin and moderation tools
#   - Anti-cheat protection (24 different protection types)
#   - Backup and maintenance settings
#   - Steam integration and workshop support

# Enable automatic export of all variables
set -a

# Players can hurt and kill other players
PVP="${PVP:-not-custom-set}"

# Game time stops when there are no players online
PAUSE_EMPTY="${PAUSE_EMPTY:-not-custom-set}"

# Toggles global chat on or off.
GLOBAL_CHAT="${GLOBAL_CHAT:-not-custom-set}"

# Chat streams available to players
CHAT_STREAMS="${CHAT_STREAMS:-not-custom-set}"

# Clients may join without already having an account in the whitelist. If set to false, administrators must manually create username/password combos.
OPEN="${OPEN:-not-custom-set}"

# The first welcome message visible in the chat panel. This will be displayed immediately after player login.
SERVER_WELCOME_MESSAGE="${SERVER_WELCOME_MESSAGE:-not-custom-set}"

# Add unknown usernames to the whitelist when players join. Clients will supply their own username/password on joining. (This is for Open=true servers)
AUTO_CREATE_USER_IN_WHITE_LIST="${AUTO_CREATE_USER_IN_WHITE_LIST:-not-custom-set}"

# Display usernames above player's heads in-game.
DISPLAY_USER_NAME="${DISPLAY_USER_NAME:-not-custom-set}"

# Display first & last name above player's heads.
SHOW_FIRST_AND_LAST_NAME="${SHOW_FIRST_AND_LAST_NAME:-not-custom-set}"

# Force every new player to spawn at these set x,y,z world coordinates. (Ignored when 0,0,0)
SPAWN_POINT="${SPAWN_POINT:-not-custom-set}"

# Players can enter and leave PVP on an individual basis. When SafetySystem=false, players are free to hurt each other at any time if PVP is enabled.
SAFETY_SYSTEM="${SAFETY_SYSTEM:-not-custom-set}"

# Display a skull icon over the head of players who have entered PVP mode
SHOW_SAFETY="${SHOW_SAFETY:-not-custom-set}"

# The time it takes for a player to enter and leave PVP mode
SAFETY_TOGGLE_TIMER="${SAFETY_TOGGLE_TIMER:-not-custom-set}"

# The delay before a player can enter or leave PVP mode again, having recently done so
SAFETY_COOLDOWN_TIMER="${SAFETY_COOLDOWN_TIMER:-not-custom-set}"

# Item types new players spawn with. Separate multiple item types with commas.
SPAWN_ITEMS="${SPAWN_ITEMS:-not-custom-set}"

# Default starting port for player data. If UDP, this is this one of two ports used.
DEFAULT_PORT="${DEFAULT_PORT:-not-custom-set}"

# UDP port for server communication
UDP_PORT="${UDP_PORT:-not-custom-set}"

# Reset ID determines if the server has undergone a soft-reset. If this number does match the client, the client must create a new character.
RESET_ID="${RESET_ID:-not-custom-set}"

# Enter the mod loading ID here. It can be found in \Steam\steamapps\workshop\modID\mods\modName\info.txt
MODS="${MODS:-not-custom-set}"

# Enter the foldername of the mod found in \Steam\steamapps\workshop\modID\mods\modName\media\maps\
MAP="${MAP:-not-custom-set}"

# Kick clients whose game files don't match the server's.
DO_LUA_CHECKSUM="${DO_LUA_CHECKSUM:-not-custom-set}"

# Deny login if the server is overloaded
DENY_LOGIN_ON_OVERLOADED_SERVER="${DENY_LOGIN_ON_OVERLOADED_SERVER:-not-custom-set}"

# Shows the server on the in-game browser. (Note: Steam-enabled servers are always visible in the Steam server browser)
PUBLIC="${PUBLIC:-not-custom-set}"

# Name of the server displayed in the in-game browser and, if applicable, the Steam browser
PUBLIC_NAME="${PUBLIC_NAME:-not-custom-set}"

# Description displayed in the in-game public server browser. Typing \n will create a new line in your description
PUBLIC_DESCRIPTION="${PUBLIC_DESCRIPTION:-not-custom-set}"

# Maximum number of players that can be on the server at one time. This excludes admins.
MAX_PLAYERS="${MAX_PLAYERS:-not-custom-set}"

# Ping limit, in milliseconds, before a player is kicked from the server. (Set to 100 to disable)
PING_LIMIT="${PING_LIMIT:-not-custom-set}"

# After X hours, all containers in the world will respawn loot. To spawn loot a container must have been looted at least once.
HOURS_FOR_LOOT_RESPAWN="${HOURS_FOR_LOOT_RESPAWN:-not-custom-set}"

# Containers with a number of items greater, or equal to, this setting will not respawn
MAX_ITEMS_FOR_LOOT_RESPAWN="${MAX_ITEMS_FOR_LOOT_RESPAWN:-not-custom-set}"

# Items will not respawn in buildings that players have barricaded or built in
CONSTRUCTION_PREVENTS_LOOT_RESPAWN="${CONSTRUCTION_PREVENTS_LOOT_RESPAWN:-not-custom-set}"

# Remove player accounts from the whitelist after death. This prevents players creating a new character after death on Open=false servers
DROP_OFF_WHITE_LIST_AFTER_DEATH="${DROP_OFF_WHITE_LIST_AFTER_DEATH:-not-custom-set}"

# All forms of fire are disabled - except for campfires
NO_FIRE="${NO_FIRE:-not-custom-set}"

# If checked, every time a player dies a global message will be displayed in the chat
ANNOUNCE_DEATH="${ANNOUNCE_DEATH:-not-custom-set}"

# The number of in-game minutes it takes to read one page of a book
MINUTES_PER_PAGE="${MINUTES_PER_PAGE:-not-custom-set}"

# Loaded parts of the map are saved after this set number of real-world minutes have passed.
SAVE_WORLD_EVERY_MINUTES="${SAVE_WORLD_EVERY_MINUTES:-not-custom-set}"

# Both admins and players can claim safehouses
PLAYER_SAFEHOUSE="${PLAYER_SAFEHOUSE:-not-custom-set}"

# Only admins can claim safehouses
ADMIN_SAFEHOUSE="${ADMIN_SAFEHOUSE:-not-custom-set}"

# Allow non-members to enter a safehouse without being invited
SAFEHOUSE_ALLOW_TREPASS="${SAFEHOUSE_ALLOW_TREPASS:-not-custom-set}"

# Allow fire to damage safehouses
SAFEHOUSE_ALLOW_FIRE="${SAFEHOUSE_ALLOW_FIRE:-not-custom-set}"

# Allow non-members to take items from safehouses
SAFEHOUSE_ALLOW_LOOT="${SAFEHOUSE_ALLOW_LOOT:-not-custom-set}"

# Players will respawn in a safehouse that they were a member of before they died
SAFEHOUSE_ALLOW_RESPAWN="${SAFEHOUSE_ALLOW_RESPAWN:-not-custom-set}"

# Players must have survived this number of in-game days before they are allowed to claim a safehouse
SAFEHOUSE_DAY_SURVIVED_TO_CLAIM="${SAFEHOUSE_DAY_SURVIVED_TO_CLAIM:-not-custom-set}"

# Players are automatically removed from a safehouse they have not visited for this many real-world hours
SAFE_HOUSE_REMOVAL_TIME="${SAFE_HOUSE_REMOVAL_TIME:-not-custom-set}"

# Governs whether players can claim non-residential buildings.
SAFEHOUSE_ALLOW_NON_RESIDENTIAL="${SAFEHOUSE_ALLOW_NON_RESIDENTIAL:-not-custom-set}"

# Allow players to destroy world objects with sledgehammers
ALLOW_DESTRUCTION_BY_SLEDGEHAMMER="${ALLOW_DESTRUCTION_BY_SLEDGEHAMMER:-not-custom-set}"

# Allow players to destroy world objects only in their safehouse (require AllowDestructionBySledgehammer to true).
SLEDGEHAMMER_ONLY_IN_SAFEHOUSE="${SLEDGEHAMMER_ONLY_IN_SAFEHOUSE:-not-custom-set}"

# Kick players that appear to be moving faster than is possible. May be buggy -- use with caution.
KICK_FAST_PLAYERS="${KICK_FAST_PLAYERS:-not-custom-set}"

# ServerPlayerID determines if a character is from another server, or single player. This value may be changed by soft resets.
SERVER_PLAYER_ID="${SERVER_PLAYER_ID:-not-custom-set}"

# The port for the RCON (Remote Console)
RCON_PORT="${RCON_PORT:-27015}"

# RCON password (Pick a strong password)
RCON_PASSWORD="${RCON_PASSWORD:-admin}"

# Enables global text chat integration with a Discord channel
DISCORD_ENABLE="${DISCORD_ENABLE:-not-custom-set}"

# Discord bot access token
DISCORD_TOKEN="${DISCORD_TOKEN:-not-custom-set}"

# The Discord channel name. (Try the separate channel ID option if having difficulties)
DISCORD_CHANNEL="${DISCORD_CHANNEL:-not-custom-set}"

# The Discord channel ID. (Use if having difficulties with Discord channel name option)
DISCORD_CHANNEL_ID="${DISCORD_CHANNEL_ID:-not-custom-set}"

# Clients must know this password to join the server. (Ignored when hosting a server via the Host button)
PASSWORD="${PASSWORD:-not-custom-set}"

# Limits the number of different accounts a single Steam user may create on this server. Ignored when using the Hosts button.
MAX_ACCOUNTS_PER_USER="${MAX_ACCOUNTS_PER_USER:-not-custom-set}"

# Allow co-op/splitscreen players
ALLOW_COOP="${ALLOW_COOP:-not-custom-set}"

# Players are allowed to sleep when their survivor becomes tired, but they do not NEED to sleep
SLEEP_ALLOWED="${SLEEP_ALLOWED:-not-custom-set}"

# Players get tired and need to sleep. (Ignored if SleepAllowed=false)
SLEEP_NEEDED="${SLEEP_NEEDED:-not-custom-set}"

# If true, players can be knocked down
KNOCKED_DOWN_ALLOWED="${KNOCKED_DOWN_ALLOWED:-not-custom-set}"

# If true, sneaking players are hidden from others
SNEAK_MODE_HIDE_FROM_OTHER_PLAYERS="${SNEAK_MODE_HIDE_FROM_OTHER_PLAYERS:-not-custom-set}"

# List Workshop Mod IDs for the server to download. Each must be separated by a semicolon.
WORKSHOP_ITEMS="${WORKSHOP_ITEMS:-not-custom-set}"

# Show Steam usernames and avatars in the Players list. Can be true (visible to everyone), false (visible to no one), or admin (visible to only admins)
STEAM_SCOREBOARD="${STEAM_SCOREBOARD:-not-custom-set}"

# Attempt to configure a UPnP-enabled internet gateway to automatically setup port forwarding rules.
UPNP="${UPNP:-not-custom-set}"

# VOIP is enabled when checked
VOICE_ENABLE="${VOICE_ENABLE:-not-custom-set}"

# The minimum tile distance over which VOIP sounds can be heard.
VOICE_MIN_DISTANCE="${VOICE_MIN_DISTANCE:-not-custom-set}"

# The maximum tile distance over which VOIP sounds can be heard.
VOICE_MAX_DISTANCE="${VOICE_MAX_DISTANCE:-not-custom-set}"

# Toggle directional audio for VOIP
VOICE_3D="${VOICE_3D:-not-custom-set}"

# Maximum speed limit for vehicles
SPEED_LIMIT="${SPEED_LIMIT:-not-custom-set}"

# Enable login queue for server
LOGIN_QUEUE_ENABLED="${LOGIN_QUEUE_ENABLED:-not-custom-set}"

# Timeout for login queue connection
LOGIN_QUEUE_CONNECT_TIMEOUT="${LOGIN_QUEUE_CONNECT_TIMEOUT:-not-custom-set}"

# Set the IP from which the server is broadcast. This is for network configurations with multiple IP addresses, such as server farms
SERVER_BROWSER_ANNOUNCED_IP="${SERVER_BROWSER_ANNOUNCED_IP:-not-custom-set}"

# Players can respawn in-game at the coordinates where they died
PLAYER_RESPAWN_WITH_SELF="${PLAYER_RESPAWN_WITH_SELF:-not-custom-set}"

# Players can respawn in-game at a split screen / Remote Play player's location
PLAYER_RESPAWN_WITH_OTHER="${PLAYER_RESPAWN_WITH_OTHER:-not-custom-set}"

# Governs how fast time passes while players sleep. Value multiplies the speed of the time that passes during sleeping.
FAST_FORWARD_MULTIPLIER="${FAST_FORWARD_MULTIPLIER:-not-custom-set}"

# Safehouse acts like a normal house if a member of the safehouse is connected (so secure when players are offline)
DISABLE_SAFEHOUSE_WHEN_PLAYER_CONNECTED="${DISABLE_SAFEHOUSE_WHEN_PLAYER_CONNECTED:-not-custom-set}"

# Players can create factions when true
FACTION="${FACTION:-not-custom-set}"

# Players must survive this number of in-game days before being allowed to create a faction
FACTION_DAY_SURVIVED_TO_CREATE="${FACTION_DAY_SURVIVED_TO_CREATE:-not-custom-set}"

# Number of players required as faction members before the faction owner can create a group tag
FACTION_PLAYERS_REQUIRED_FOR_TAG="${FACTION_PLAYERS_REQUIRED_FOR_TAG:-not-custom-set}"

# Disables radio transmissions from players with an access level
DISABLE_RADIO_STAFF="${DISABLE_RADIO_STAFF:-not-custom-set}"

# Disables radio transmissions from players with 'admin' access level
DISABLE_RADIO_ADMIN="${DISABLE_RADIO_ADMIN:-not-custom-set}"

# Disables radio transmissions from players with 'gm' access level
DISABLE_RADIO_GM="${DISABLE_RADIO_GM:-not-custom-set}"

# Disables radio transmissions from players with 'overseer' access level
DISABLE_RADIO_OVERSEER="${DISABLE_RADIO_OVERSEER:-not-custom-set}"

# Disables radio transmissions from players with 'moderator' access level
DISABLE_RADIO_MODERATOR="${DISABLE_RADIO_MODERATOR:-not-custom-set}"

# Disables radio transmissions from invisible players
DISABLE_RADIO_INVISIBLE="${DISABLE_RADIO_INVISIBLE:-not-custom-set}"

# Semicolon-separated list of commands that will not be written to the cmd.txt server log.
CLIENT_COMMAND_FILTER="${CLIENT_COMMAND_FILTER:-not-custom-set}"

# Semicolon-separated list of actions that will be written to the ClientActionLogs.txt server log.
CLIENT_ACTION_LOGS="${CLIENT_ACTION_LOGS:-not-custom-set}"

# Track changes in player perk levels in PerkLog.txt server log
PERK_LOGS="${PERK_LOGS:-not-custom-set}"

# Maximum number of items that can be placed in a container. Zero means there is no limit.
ITEM_NUMBERS_LIMIT_PER_CONTAINER="${ITEM_NUMBERS_LIMIT_PER_CONTAINER:-not-custom-set}"

# Number of days before old blood splats are removed. Zero means they will never disappear.
BLOOD_SPLAT_LIFESPAN_DAYS="${BLOOD_SPLAT_LIFESPAN_DAYS:-not-custom-set}"

# Allow use of non-ASCII (cyrillic etc) characters in usernames
ALLOW_NON_ASCII_USERNAME="${ALLOW_NON_ASCII_USERNAME:-not-custom-set}"

BAN_KICK_GLOBAL_SOUND="${BAN_KICK_GLOBAL_SOUND:-not-custom-set}"

# If enabled, when HoursForCorpseRemoval triggers, it will also remove player’s corpses from the ground.
REMOVE_PLAYER_CORPSES_ON_CORPSE_REMOVAL="${REMOVE_PLAYER_CORPSES_ON_CORPSE_REMOVAL:-not-custom-set}"

# If true, player can use the "delete all" button on bins.
TRASH_DELETE_ALL="${TRASH_DELETE_ALL:-not-custom-set}"

# If true, player can hit again when struck by another player.
PVP_MELEE_WHILE_HIT_REACTION="${PVP_MELEE_WHILE_HIT_REACTION:-not-custom-set}"

# If true, players will have to mouse over someone to see their display name.
MOUSE_OVER_TO_SEE_DISPLAY_NAME="${MOUSE_OVER_TO_SEE_DISPLAY_NAME:-not-custom-set}"

# If true, automatically hide the player you can't see (like zombies).
HIDE_PLAYERS_BEHIND_YOU="${HIDE_PLAYERS_BEHIND_YOU:-not-custom-set}"

# Damage multiplier for PVP melee attacks.
PVP_MELEE_DAMAGE_MODIFIER="${PVP_MELEE_DAMAGE_MODIFIER:-not-custom-set}"

# Damage multiplier for PVP ranged attacks.
PVP_FIREARM_DAMAGE_MODIFIER="${PVP_FIREARM_DAMAGE_MODIFIER:-not-custom-set}"

# Modify the range of zombie attraction to cars. (Lower values can help with lag.)
CAR_ENGINE_ATTRACTION_MODIFIER="${CAR_ENGINE_ATTRACTION_MODIFIER:-not-custom-set}"

# Governs whether players bump (and knock over) other players when running through them.
PLAYER_BUMP_PLAYER="${PLAYER_BUMP_PLAYER:-not-custom-set}"

# Controls display of remote players on the in-game map. 1=Hidden 2=Friends 3=Everyone
MAP_REMOTE_PLAYER_VISIBILITY="${MAP_REMOTE_PLAYER_VISIBILITY:-not-custom-set}"

# Number of backups to keep
BACKUPS_COUNT="${BACKUPS_COUNT:-not-custom-set}"

# Enable backups on server start
BACKUPS_ON_START="${BACKUPS_ON_START:-not-custom-set}"

# Enable backups on version change
BACKUPS_ON_VERSION_CHANGE="${BACKUPS_ON_VERSION_CHANGE:-not-custom-set}"

# Period between backups
BACKUPS_PERIOD="${BACKUPS_PERIOD:-not-custom-set}"

# Disables anti-cheat protection for type 1.
ANTI_CHEAT_PROTECTION_TYPE_1="${ANTI_CHEAT_PROTECTION_TYPE_1:-not-custom-set}"

# Disables anti-cheat protection for type 2.
ANTI_CHEAT_PROTECTION_TYPE_2="${ANTI_CHEAT_PROTECTION_TYPE_2:-not-custom-set}"

# Disables anti-cheat protection for type 3.
ANTI_CHEAT_PROTECTION_TYPE_3="${ANTI_CHEAT_PROTECTION_TYPE_3:-not-custom-set}"

# Disables anti-cheat protection for type 4.
ANTI_CHEAT_PROTECTION_TYPE_4="${ANTI_CHEAT_PROTECTION_TYPE_4:-not-custom-set}"

# Disables anti-cheat protection for type 5.
ANTI_CHEAT_PROTECTION_TYPE_5="${ANTI_CHEAT_PROTECTION_TYPE_5:-not-custom-set}"

# Disables anti-cheat protection for type 6.
ANTI_CHEAT_PROTECTION_TYPE_6="${ANTI_CHEAT_PROTECTION_TYPE_6:-not-custom-set}"

# Disables anti-cheat protection for type 7.
ANTI_CHEAT_PROTECTION_TYPE_7="${ANTI_CHEAT_PROTECTION_TYPE_7:-not-custom-set}"

# Disables anti-cheat protection for type 8.
ANTI_CHEAT_PROTECTION_TYPE_8="${ANTI_CHEAT_PROTECTION_TYPE_8:-not-custom-set}"

# Disables anti-cheat protection for type 9.
ANTI_CHEAT_PROTECTION_TYPE_9="${ANTI_CHEAT_PROTECTION_TYPE_9:-not-custom-set}"

# Disables anti-cheat protection for type 10.
ANTI_CHEAT_PROTECTION_TYPE_10="${ANTI_CHEAT_PROTECTION_TYPE_10:-not-custom-set}"

# Disables anti-cheat protection for type 11.
ANTI_CHEAT_PROTECTION_TYPE_11="${ANTI_CHEAT_PROTECTION_TYPE_11:-not-custom-set}"

# Disables anti-cheat protection for type 12.
ANTI_CHEAT_PROTECTION_TYPE_12="${ANTI_CHEAT_PROTECTION_TYPE_12:-not-custom-set}"

# Disables anti-cheat protection for type 13.
ANTI_CHEAT_PROTECTION_TYPE_13="${ANTI_CHEAT_PROTECTION_TYPE_13:-not-custom-set}"

# Disables anti-cheat protection for type 14.
ANTI_CHEAT_PROTECTION_TYPE_14="${ANTI_CHEAT_PROTECTION_TYPE_14:-not-custom-set}"

# Disables anti-cheat protection for type 15.
ANTI_CHEAT_PROTECTION_TYPE_15="${ANTI_CHEAT_PROTECTION_TYPE_15:-not-custom-set}"

# Disables anti-cheat protection for type 16.
ANTI_CHEAT_PROTECTION_TYPE_16="${ANTI_CHEAT_PROTECTION_TYPE_16:-not-custom-set}"

# Disables anti-cheat protection for type 17.
ANTI_CHEAT_PROTECTION_TYPE_17="${ANTI_CHEAT_PROTECTION_TYPE_17:-not-custom-set}"

# Disables anti-cheat protection for type 18.
ANTI_CHEAT_PROTECTION_TYPE_18="${ANTI_CHEAT_PROTECTION_TYPE_18:-not-custom-set}"

# Disables anti-cheat protection for type 19.
ANTI_CHEAT_PROTECTION_TYPE_19="${ANTI_CHEAT_PROTECTION_TYPE_19:-not-custom-set}"

# Disables anti-cheat protection for type 20.
ANTI_CHEAT_PROTECTION_TYPE_20="${ANTI_CHEAT_PROTECTION_TYPE_20:-not-custom-set}"

# Disables anti-cheat protection for type 21.
ANTI_CHEAT_PROTECTION_TYPE_21="${ANTI_CHEAT_PROTECTION_TYPE_21:-not-custom-set}"

# Disables anti-cheat protection for type 22.
ANTI_CHEAT_PROTECTION_TYPE_22="${ANTI_CHEAT_PROTECTION_TYPE_22:-not-custom-set}"

# Disables anti-cheat protection for type 23.
ANTI_CHEAT_PROTECTION_TYPE_23="${ANTI_CHEAT_PROTECTION_TYPE_23:-not-custom-set}"

# Disables anti-cheat protection for type 24.
ANTI_CHEAT_PROTECTION_TYPE_24="${ANTI_CHEAT_PROTECTION_TYPE_24:-not-custom-set}"

# Threshold value multiplier for anti-cheat protection: type 2. Minimum=1.00 Maximum=10.00
ANTI_CHEAT_PROTECTION_TYPE_2_THRESHOLD_MULTIPLIER="${ANTI_CHEAT_PROTECTION_TYPE_2_THRESHOLD_MULTIPLIER:-not-custom-set}"

# Threshold value multiplier for anti-cheat protection: type 3. Minimum=1.00 Maximum=10.00
ANTI_CHEAT_PROTECTION_TYPE_3_THRESHOLD_MULTIPLIER="${ANTI_CHEAT_PROTECTION_TYPE_3_THRESHOLD_MULTIPLIER:-not-custom-set}"

# Threshold value multiplier for anti-cheat protection: type 4. Minimum=1.00 Maximum=10.00
ANTI_CHEAT_PROTECTION_TYPE_4_THRESHOLD_MULTIPLIER="${ANTI_CHEAT_PROTECTION_TYPE_4_THRESHOLD_MULTIPLIER:-not-custom-set}"

# Threshold value multiplier for anti-cheat protection: type 9. Minimum=1.00 Maximum=10.00
ANTI_CHEAT_PROTECTION_TYPE_9_THRESHOLD_MULTIPLIER="${ANTI_CHEAT_PROTECTION_TYPE_9_THRESHOLD_MULTIPLIER:-not-custom-set}"

# Threshold value multiplier for anti-cheat protection: type 15. Minimum=1.00 Maximum=10.00
ANTI_CHEAT_PROTECTION_TYPE_15_THRESHOLD_MULTIPLIER="${ANTI_CHEAT_PROTECTION_TYPE_15_THRESHOLD_MULTIPLIER:-not-custom-set}"

# Threshold value multiplier for anti-cheat protection: type 20. Minimum=1.00 Maximum=10.00
ANTI_CHEAT_PROTECTION_TYPE_20_THRESHOLD_MULTIPLIER="${ANTI_CHEAT_PROTECTION_TYPE_20_THRESHOLD_MULTIPLIER:-not-custom-set}"

# Threshold value multiplier for anti-cheat protection: type 22. Minimum=1.00 Maximum=10.00
ANTI_CHEAT_PROTECTION_TYPE_22_THRESHOLD_MULTIPLIER="${ANTI_CHEAT_PROTECTION_TYPE_22_THRESHOLD_MULTIPLIER:-not-custom-set}"

# Threshold value multiplier for anti-cheat protection: type 24. Minimum=1.00 Maximum=10.00
ANTI_CHEAT_PROTECTION_TYPE_24_THRESHOLD_MULTIPLIER="${ANTI_CHEAT_PROTECTION_TYPE_24_THRESHOLD_MULTIPLIER:-not-custom-set}"

# Disable automatic export
set +a
