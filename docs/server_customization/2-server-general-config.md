# Server Configuration Settings

## Description

This document lists all the environment variables you can customize for Project Zomboid server general configuration settings. These variables correspond to the server's `.ini` file and control general server behavior, gameplay mechanics, PvP settings, anti-cheat protection, and various multiplayer features. They allow you to configure your server without modifying any files, simply override them when starting your container.

**All variables listed below can be customized using Docker's `-e` flag.**

## How to Override Variables

Use Docker Compose and add your variables under the `environment:` key:

```yaml
version: "3.8"
services:
  zomboid-server:
    image: <your-image>
    environment:
      - SERVER_NAME=My Server
      - PORT=16262
      - SERVER_MEMORY=4096m
      - ADMIN_USERNAME=admin
      - ADMIN_PASSWORD=your_password
    ports:
      - "16262:16262"
```

## Available Configuration Variables

The following table shows all variables you can override, their purpose, and default values:

| Variable Name                             | Description                                                             | Default Value                                                                                     |
| ----------------------------------------- | ----------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| `PVP`                                     | Players can hurt and kill other players                                 | `true`                                                                                            |
| `PAUSE_EMPTY`                             | Game time stops when there are no players online                        | `true`                                                                                            |
| `GLOBAL_CHAT`                             | Toggles global chat on or off                                           | `true`                                                                                            |
| `CHAT_STREAMS`                            | Chat streams available to players                                       | `"s,r,a,w,y,sh,f,all"`                                                                            |
| `OPEN`                                    | Clients may join without already having an account in the whitelist     | `true`                                                                                            |
| `SERVER_WELCOME_MESSAGE`                  | The first welcome message visible in the chat panel                     | _(long default message)_                                                                          |
| `AUTO_CREATE_USER_IN_WHITE_LIST`          | Add unknown usernames to the whitelist when players join                | `false`                                                                                           |
| `DISPLAY_USER_NAME`                       | Display usernames above player's heads in-game                          | `true`                                                                                            |
| `SHOW_FIRST_AND_LAST_NAME`                | Display first & last name above player's heads                          | `false`                                                                                           |
| `SPAWN_POINT`                             | Force every new player to spawn at these set x,y,z world coordinates    | `"0,0,0"`                                                                                         |
| `SAFETY_SYSTEM`                           | Players can enter and leave PVP on an individual basis                  | `true`                                                                                            |
| `SHOW_SAFETY`                             | Display a skull icon over the head of players who have entered PVP mode | `true`                                                                                            |
| `SAFETY_TOGGLE_TIMER`                     | The time it takes for a player to enter and leave PVP mode              | `2`                                                                                               |
| `SAFETY_COOLDOWN_TIMER`                   | The delay before a player can enter or leave PVP mode again             | `3`                                                                                               |
| `SPAWN_ITEMS`                             | Item types new players spawn with                                       | _(empty)_                                                                                         |
| `DEFAULT_PORT`                            | Default starting port for player data                                   | `16261`                                                                                           |
| `UDP_PORT`                                | UDP port for server communication                                       | `16262`                                                                                           |
| `RESET_ID`                                | Reset ID determines if the server has undergone a soft-reset            | `8267201`                                                                                         |
| `MODS`                                    | Enter the mod loading ID here                                           | _(empty)_                                                                                         |
| `MAP`                                     | Enter the foldername of the mod found in maps folder                    | `"Muldraugh, KY"`                                                                                 |
| `DO_LUA_CHECKSUM`                         | Kick clients whose game files don't match the server's                  | `true`                                                                                            |
| `DENY_LOGIN_ON_OVERLOADED_SERVER`         | Deny login if the server is overloaded                                  | `true`                                                                                            |
| `PUBLIC`                                  | Shows the server on the in-game browser                                 | `false`                                                                                           |
| `PUBLIC_NAME`                             | Name of the server displayed in the in-game browser                     | `"My PZ Server"`                                                                                  |
| `PUBLIC_DESCRIPTION`                      | Description displayed in the in-game public server browser              | _(empty)_                                                                                         |
| `MAX_PLAYERS`                             | Maximum number of players that can be on the server at one time         | `32`                                                                                              |
| `PING_LIMIT`                              | Ping limit, in milliseconds, before a player is kicked                  | `400`                                                                                             |
| `HOURS_FOR_LOOT_RESPAWN`                  | After X hours, all containers in the world will respawn loot            | `0`                                                                                               |
| `MAX_ITEMS_FOR_LOOT_RESPAWN`              | Containers with items >= this setting will not respawn                  | `4`                                                                                               |
| `CONSTRUCTION_PREVENTS_LOOT_RESPAWN`      | Items will not respawn in buildings that players have barricaded        | `true`                                                                                            |
| `DROP_OFF_WHITE_LIST_AFTER_DEATH`         | Remove player accounts from the whitelist after death                   | `false`                                                                                           |
| `NO_FIRE`                                 | All forms of fire are disabled - except for campfires                   | `false`                                                                                           |
| `ANNOUNCE_DEATH`                          | Every time a player dies a global message will be displayed             | `false`                                                                                           |
| `MINUTES_PER_PAGE`                        | The number of in-game minutes it takes to read one page of a book       | `1.0`                                                                                             |
| `SAVE_WORLD_EVERY_MINUTES`                | Loaded parts of the map are saved after this set number of minutes      | `0`                                                                                               |
| `PLAYER_SAFEHOUSE`                        | Both admins and players can claim safehouses                            | `false`                                                                                           |
| `ADMIN_SAFEHOUSE`                         | Only admins can claim safehouses                                        | `false`                                                                                           |
| `SAFEHOUSE_ALLOW_TREPASS`                 | Allow non-members to enter a safehouse without being invited            | `true`                                                                                            |
| `SAFEHOUSE_ALLOW_FIRE`                    | Allow fire to damage safehouses                                         | `true`                                                                                            |
| `SAFEHOUSE_ALLOW_LOOT`                    | Allow non-members to take items from safehouses                         | `true`                                                                                            |
| `SAFEHOUSE_ALLOW_RESPAWN`                 | Players will respawn in a safehouse that they were a member of          | `false`                                                                                           |
| `SAFEHOUSE_DAY_SURVIVED_TO_CLAIM`         | Players must have survived this number of days before claiming          | `0`                                                                                               |
| `SAFE_HOUSE_REMOVAL_TIME`                 | Players are removed from safehouse after this many hours                | `144`                                                                                             |
| `SAFEHOUSE_ALLOW_NON_RESIDENTIAL`         | Allow players to claim non-residential buildings                        | `false`                                                                                           |
| `ALLOW_DESTRUCTION_BY_SLEDGEHAMMER`       | Allow players to destroy world objects with sledgehammers               | `true`                                                                                            |
| `SLEDGEHAMMER_ONLY_IN_SAFEHOUSE`          | Allow destruction only in their safehouse                               | `false`                                                                                           |
| `KICK_FAST_PLAYERS`                       | Kick players that appear to be moving faster than possible              | `false`                                                                                           |
| `SERVER_PLAYER_ID`                        | ServerPlayerID determines if a character is from another server         | `934857515`                                                                                       |
| `RCON_PORT`                               | The port for the RCON (Remote Console)                                  | `27015`                                                                                           |
| `RCON_PASSWORD`                           | RCON password                                                           | `admin`                                                                                           |
| `DISCORD_ENABLE`                          | Enables global text chat integration with a Discord channel             | `false`                                                                                           |
| `DISCORD_TOKEN`                           | Discord bot access token                                                | _(empty)_                                                                                         |
| `DISCORD_CHANNEL`                         | The Discord channel name                                                | _(empty)_                                                                                         |
| `DISCORD_CHANNEL_ID`                      | The Discord channel ID                                                  | _(empty)_                                                                                         |
| `PASSWORD`                                | Clients must know this password to join the server                      | _(empty)_                                                                                         |
| `MAX_ACCOUNTS_PER_USER`                   | Limits the number of different accounts a single Steam user may create  | `0`                                                                                               |
| `ALLOW_COOP`                              | Allow co-op/splitscreen players                                         | `true`                                                                                            |
| `SLEEP_ALLOWED`                           | Players are allowed to sleep when their survivor becomes tired          | `false`                                                                                           |
| `SLEEP_NEEDED`                            | Players get tired and need to sleep                                     | `false`                                                                                           |
| `KNOCKED_DOWN_ALLOWED`                    | If true, players can be knocked down                                    | `true`                                                                                            |
| `SNEAK_MODE_HIDE_FROM_OTHER_PLAYERS`      | If true, sneaking players are hidden from others                        | `true`                                                                                            |
| `WORKSHOP_ITEMS`                          | List Workshop Mod IDs for the server to download                        | _(empty)_                                                                                         |
| `STEAM_SCOREBOARD`                        | Show Steam usernames and avatars in the Players list                    | `true`                                                                                            |
| `UPNP`                                    | Attempt to configure UPnP for automatic port forwarding                 | `true`                                                                                            |
| `VOICE_ENABLE`                            | VOIP is enabled when checked                                            | `true`                                                                                            |
| `VOICE_MIN_DISTANCE`                      | The minimum tile distance over which VOIP sounds can be heard           | `10.0`                                                                                            |
| `VOICE_MAX_DISTANCE`                      | The maximum tile distance over which VOIP sounds can be heard           | `100.0`                                                                                           |
| `VOICE_3D`                                | Toggle directional audio for VOIP                                       | `true`                                                                                            |
| `SPEED_LIMIT`                             | Maximum speed limit for vehicles                                        | `70.0`                                                                                            |
| `LOGIN_QUEUE_ENABLED`                     | Enable login queue for server                                           | `false`                                                                                           |
| `LOGIN_QUEUE_CONNECT_TIMEOUT`             | Timeout for login queue connection                                      | `60`                                                                                              |
| `SERVER_BROWSER_ANNOUNCED_IP`             | Set the IP from which the server is broadcast                           | _(empty)_                                                                                         |
| `PLAYER_RESPAWN_WITH_SELF`                | Players can respawn at the coordinates where they died                  | `false`                                                                                           |
| `PLAYER_RESPAWN_WITH_OTHER`               | Players can respawn at a split screen player's location                 | `false`                                                                                           |
| `FAST_FORWARD_MULTIPLIER`                 | How fast time passes while players sleep                                | `40.0`                                                                                            |
| `DISABLE_SAFEHOUSE_WHEN_PLAYER_CONNECTED` | Safehouse acts like normal house if member is connected                 | `false`                                                                                           |
| `FACTION`                                 | Players can create factions when true                                   | `true`                                                                                            |
| `FACTION_DAY_SURVIVED_TO_CREATE`          | Players must survive this number of days before creating faction        | `0`                                                                                               |
| `FACTION_PLAYERS_REQUIRED_FOR_TAG`        | Number of players required before faction owner can create group tag    | `1`                                                                                               |
| `DISABLE_RADIO_STAFF`                     | Disables radio transmissions from players with an access level          | `false`                                                                                           |
| `DISABLE_RADIO_ADMIN`                     | Disables radio transmissions from players with 'admin' access           | `true`                                                                                            |
| `DISABLE_RADIO_GM`                        | Disables radio transmissions from players with 'gm' access              | `true`                                                                                            |
| `DISABLE_RADIO_OVERSEER`                  | Disables radio transmissions from players with 'overseer' access        | `false`                                                                                           |
| `DISABLE_RADIO_MODERATOR`                 | Disables radio transmissions from players with 'moderator' access       | `false`                                                                                           |
| `DISABLE_RADIO_INVISIBLE`                 | Disables radio transmissions from invisible players                     | `true`                                                                                            |
| `CLIENT_COMMAND_FILTER`                   | Commands that will not be written to the cmd.txt server log             | `"-vehicle.*;+vehicle.damageWindow;+vehicle.fixPart;+vehicle.installPart;+vehicle.uninstallPart"` |
| `CLIENT_ACTION_LOGS`                      | Actions that will be written to the ClientActionLogs.txt server log     | `"ISEnterVehicle;ISExitVehicle;ISTakeEngineParts;"`                                               |
| `PERK_LOGS`                               | Track changes in player perk levels in PerkLog.txt server log           | `true`                                                                                            |
| `ITEM_NUMBERS_LIMIT_PER_CONTAINER`        | Maximum number of items that can be placed in a container               | `0`                                                                                               |
| `BLOOD_SPLAT_LIFESPAN_DAYS`               | Number of days before old blood splats are removed                      | `0`                                                                                               |
| `ALLOW_NON_ASCII_USERNAME`                | Allow use of non-ASCII characters in usernames                          | `false`                                                                                           |
| `BAN_KICK_GLOBAL_SOUND`                   | _(No description available)_                                            | `true`                                                                                            |
| `REMOVE_PLAYER_CORPSES_ON_CORPSE_REMOVAL` | Remove player's corpses when HoursForCorpseRemoval triggers             | `false`                                                                                           |
| `TRASH_DELETE_ALL`                        | Player can use the "delete all" button on bins                          | `false`                                                                                           |
| `PVP_MELEE_WHILE_HIT_REACTION`            | Player can hit again when struck by another player                      | `false`                                                                                           |
| `MOUSE_OVER_TO_SEE_DISPLAY_NAME`          | Players will have to mouse over someone to see their display name       | `true`                                                                                            |
| `HIDE_PLAYERS_BEHIND_YOU`                 | Automatically hide the player you can't see                             | `true`                                                                                            |
| `PVP_MELEE_DAMAGE_MODIFIER`               | Damage multiplier for PVP melee attacks                                 | `30.0`                                                                                            |
| `PVP_FIREARM_DAMAGE_MODIFIER`             | Damage multiplier for PVP ranged attacks                                | `50.0`                                                                                            |
| `CAR_ENGINE_ATTRACTION_MODIFIER`          | Modify the range of zombie attraction to cars                           | `0.5`                                                                                             |
| `PLAYER_BUMP_PLAYER`                      | Players bump other players when running through them                    | `false`                                                                                           |
| `MAP_REMOTE_PLAYER_VISIBILITY`            | Controls display of remote players on the in-game map                   | `1`                                                                                               |
| `BACKUPS_COUNT`                           | Number of backups to keep                                               | `5`                                                                                               |
| `BACKUPS_ON_START`                        | Enable backups on server start                                          | `true`                                                                                            |
| `BACKUPS_ON_VERSION_CHANGE`               | Enable backups on version change                                        | `true`                                                                                            |
| `BACKUPS_PERIOD`                          | Period between backups                                                  | `0`                                                                                               |

## Anti-Cheat Protection Variables

| Variable Name                                                     | Description                                                  | Default Value |
| ----------------------------------------------------------------- | ------------------------------------------------------------ | ------------- |
| `ANTI_CHEAT_PROTECTION_TYPE_1` to `ANTI_CHEAT_PROTECTION_TYPE_24` | Enable/disable anti-cheat protection types 1-24              | `true`        |
| `ANTI_CHEAT_PROTECTION_TYPE_2_THRESHOLD_MULTIPLIER`               | Threshold value multiplier for anti-cheat protection type 2  | `3.0`         |
| `ANTI_CHEAT_PROTECTION_TYPE_3_THRESHOLD_MULTIPLIER`               | Threshold value multiplier for anti-cheat protection type 3  | `1.0`         |
| `ANTI_CHEAT_PROTECTION_TYPE_4_THRESHOLD_MULTIPLIER`               | Threshold value multiplier for anti-cheat protection type 4  | `1.0`         |
| `ANTI_CHEAT_PROTECTION_TYPE_9_THRESHOLD_MULTIPLIER`               | Threshold value multiplier for anti-cheat protection type 9  | `1.0`         |
| `ANTI_CHEAT_PROTECTION_TYPE_15_THRESHOLD_MULTIPLIER`              | Threshold value multiplier for anti-cheat protection type 15 | `1.0`         |
| `ANTI_CHEAT_PROTECTION_TYPE_20_THRESHOLD_MULTIPLIER`              | Threshold value multiplier for anti-cheat protection type 20 | `1.0`         |
| `ANTI_CHEAT_PROTECTION_TYPE_22_THRESHOLD_MULTIPLIER`              | Threshold value multiplier for anti-cheat protection type 22 | `1.0`         |
| `ANTI_CHEAT_PROTECTION_TYPE_24_THRESHOLD_MULTIPLIER`              | Threshold value multiplier for anti-cheat protection type 24 | `6.0`         |

## Most Common Variables to Change

Here are the variables you'll most likely want to customize:

- **`PUBLIC`**: Make your server visible in browser (`true`/`false`)
- **`PUBLIC_NAME`**: Your server's display name
- **`MAX_PLAYERS`**: Maximum number of players (default: 32)
- **`PVP`**: Enable/disable player vs player combat
- **`PASSWORD`**: Server password for private servers
- **`MAP`**: Game map to use
- **`MODS`** & **`WORKSHOP_ITEMS`**: Server mods and Steam Workshop items (Coming soon...)

## Quick Reference

### Boolean Values

Use `true`/`false` for most settings, or `0`/`1` for some compatibility settings

### Numeric Values

- Distances are in tile units
- Time values vary by context (minutes, hours, days)
- Multipliers are decimal values (e.g., `1.0`, `30.0`)

### Special Formats

- **Coordinates**: Use format `"x,y,z"` (e.g., `"100,200,0"`)
- **Lists**: Use semicolons `;` to separate multiple items
- **Chat Streams**: Use commas to separate stream types
