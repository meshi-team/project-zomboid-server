# Server startup variables flags

## Description

This document lists all the environment variables you can customize when running the Project Zomboid server in Docker. Most of these variables are used as command-line flags to initialize the server startup process. They allow you to configure your server without modifying any files, simply override them when starting your container.

**All variables listed below can be customized using Docker's `-e` flag.**

## Table of Contents

- [Description](#description)
- [Table of Contents](#table-of-contents)
- [How to Override Variables](#how-to-override-variables)
- [Available Configuration Variables](#available-configuration-variables)
- [Most Common Variables to Change](#most-common-variables-to-change)
- [Quick Reference](#quick-reference)
  - [Boolean Values](#boolean-values)
  - [Memory Values](#memory-values)

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

| Variable Name           | Description                                                                                                                                                              | Default Value                            |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------- |
| `SERVER_DIR`            | Root directory for the Project Zomboid server installation                                                                                                               | `/pzomboid-server`                       |
| `PRESETS_DIR`           | Directory containing sandbox preset configurations                                                                                                                       | `${SERVER_DIR}/media/lua/shared/Sandbox` |
| `ZOMBOID_SERVER_APP_ID` | Steam application ID for Project Zomboid dedicated server                                                                                                                | `380870`                                 |
| `SERVER_PRESET`         | Sandbox preset configuration to use                                                                                                                                      | _(empty)_                                |
| `FORCE_PRESET`          | When set to `1`, force-apply `SERVER_PRESET` even if a SandboxVars file already exists (overwrites current). Use to apply a new preset on an already initialized server. | `0`                                      |
| `SERVER_MEMORY`         | Maximum memory allocation for the Java process                                                                                                                           | `2048m`                                  |
| `SOFTRESET`             | Enable soft reset functionality (0=False, 1=True)                                                                                                                        | `0`                                      |
| `SERVER_NAME`           | Display name for the server                                                                                                                                              | `servertest`                             |
| `COOP_SERVER`           | Enable cooperative multiplayer mode (0=False, 1=True)                                                                                                                    | `0`                                      |
| `NO_STEAM`              | Disable Steam integration (0=False, 1=True)                                                                                                                              | `0`                                      |
| `CACHE_DIR`             | Directory for server cache and temporary files                                                                                                                           | `/root/Zomboid`                          |
| `DEBUG`                 | Enable debug mode for verbose logging (0=False, 1=True)                                                                                                                  | `0`                                      |
| `ADMIN_USERNAME`        | Default administrator username                                                                                                                                           | `admin`                                  |
| `ADMIN_PASSWORD`        | Default administrator password                                                                                                                                           | `admin`                                  |
| `IP`                    | IP address for the server to bind to                                                                                                                                     | _(empty)_                                |
| `PORT`                  | Primary server port for client connections                                                                                                                               | `16261`                                  |
| `STEAM_VAC`             | Enable Steam VAC (Valve Anti-Cheat)                                                                                                                                      | `true`                                   |
| `STEAM_PORT_1`          | First Steam communication port                                                                                                                                           | _(empty)_                                |
| `STEAM_PORT_2`          | Second Steam communication port                                                                                                                                          | _(empty)_                                |
| `MODFOLDERS`            | Comma-separated list of mod folder names                                                                                                                                 | `steam,mods,workshop`                    |
| `PZ_VERSION`            | Current Project Zomboid server version baked into the image; exposed for reference at runtime. Set automatically from the image if available (read-only/informational). | auto-detected from image                 |

## Most Common Variables to Change

Here are the variables you'll most likely want to customize:

- **`SERVER_NAME`**: Your server's display name
- **`PORT`**: Server port (default: 16261)
- **`SERVER_MEMORY`**: Memory allocation (e.g., "4096m" for 4GB)
- **`ADMIN_USERNAME`** & **`ADMIN_PASSWORD`**: Admin credentials ⚠️ **Change these!**

## Quick Reference

### Boolean Values

Use `0` for False and `1` for True (e.g., `DEBUG=1` to enable debug mode)

### Memory Values

Include the unit suffix: `2048m` (megabytes) or `4g` (gigabytes)
