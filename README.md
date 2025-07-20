# Project Zomboid Server

This repository provides a **Docker-based setup** for running a Project Zomboid dedicated server with advanced configuration options. It's designed for easy deployment, customizable gameplay settings, and streamlined server management.

> 💡 **New**: Built-in admin console! Use `docker exec -it zomboid-server admin-console` to access the server administration interface powered by RCON protocol.

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Features](#features)
- [Coming Soon](#coming-soon)
  - [🚀 Ready-to-Use Server Images](#-ready-to-use-server-images)
  - [🔧 Workshop \& Mod Support](#-workshop--mod-support)
- [Requirements](#requirements)
- [How to Run](#how-to-run)
  - [🔧 Build from Source](#-build-from-source)
- [Configuration](#configuration)
  - [1. Server Initialization Flags](#1-server-initialization-flags)
  - [2. Server Configuration Settings](#2-server-configuration-settings)
  - [3. Sandbox Variables](#3-sandbox-variables)
  - [Quick Setup Examples](#quick-setup-examples)
- [Server Management](#server-management)
  - [1. 🔗 Connecting to Your Server](#1--connecting-to-your-server)
  - [2. 🖥️ Accessing Server Console](#2-️-accessing-server-console)
  - [3. 💾 Volumes and Data Management](#3--volumes-and-data-management)
  - [4. 🔄 Server Updates](#4--server-updates)
- [For Developers](#for-developers)
  - [Development Environment Setup](#development-environment-setup)
  - [Code Quality Tools](#code-quality-tools)
  - [Contributing](#contributing)
- [License](#license)
- [Support](#support)

## Features

- 🐳 **Docker-based deployment** - Easy setup and deployment using Docker Compose
- 🔧 **Environment-based config** - Easy configuration through environment files
- ⚙️ **Extensive configuration** - Over 150+ configurable server and sandbox variables
- 🎮 **Admin Command Line Interface** - Built-in RCON-based console for server administration

## Coming Soon

We're working on exciting new features to enhance your Project Zomboid server experience:

### 🚀 Ready-to-Use Server Images

- **Automatic creation using GitHub Actions and GHCR** - Automated builds and publishing to GitHub Container Registry
- **Featuring the Unstable versions with tag versioning** - Support for both stable and unstable Project Zomboid builds with proper versioning

### 🔧 Workshop & Mod Support

- **Steam Workshop Integration** - Automatic mod downloading and management
- **Custom Mod Configurations** - Easy mod setup through environment variables

## Requirements

- **Docker** and **Docker Compose** installed on your system
- **4GB+ RAM** recommended (configurable via `SERVER_MEMORY`)
- **Open ports** for server communication:
  - `16261` (UDP/TCP) - Main server port
  - `8766` (UDP) - Steam query port
  - `16262-16272` (UDP) - Direct connection ports
- **Steam account** (optional, for Steam integration features)

## How to Run

### 🔧 Build from Source

1. **Clone this repository:**

   ```bash
   git clone https://github.com/meshi-team/project-zomboid-server.git
   cd project-zomboid-server
   ```

2. **Customize the docker-compose.yml file (optional):**

   Review and modify the `docker-compose.yml` file environment variables to change your server behaviour or configuration. See the [Configuration](#configuration) section below for all available options.

   ```yaml
   services:
     zomboid-server:
       container_name: zomboid-server
       build:
         context: ./zomboid-server
         dockerfile: Dockerfile
       volumes:
         - ./data:/root/Zomboid # Change this to your desired $CACHE_DIR location
       ports:
         - 16261:16261/udp # Port for the server
         - 16261:16261/tcp # TCP port for the server
         - 8766:8766/udp # Steam query port
         - 16262-16272:16262-16272/udp # Direct connection ports
       environment:
         - SERVER_PRESET=Beginner # Custom
         - ADMIN_PASSWORD=MyPassword # Custom
         - SPAWN_ITEMS=Base.Axe,Base.Bag_BigHikingBag # Custom
   ```

3. **Start the server:**

   ```bash
   docker-compose up -d
   ```

4. **Check server logs:**

   ```bash
   docker-compose logs -f zomboid-server
   ```

## Configuration

**💡 All server options can be easily customized using Docker environment variables** - simply add any variable to your `docker-compose.yml` environment section or use the `-e` flag with `docker run`.

The server uses three configuration files located in `zomboid-server/env/` that define different aspects of your server. Each file has comprehensive documentation available in the `zomboid-server/env/docs/` folder to help you understand all available options.

### 1. Server Initialization Flags

**File**: `server-init-flags.sh`  
**Documentation**: [📖 server-init-flags.md](zomboid-server/env/docs/server-init-flags.md)

Controls basic server startup parameters and command-line flags:

```yaml
environment:
  - SERVER_NAME=MyAwesomeServer
  - SERVER_MEMORY=4096m
  - PORT=16261
  - ADMIN_PASSWORD=MySecurePassword123
  - DEBUG=0
```

**Key variables**: `SERVER_NAME`, `SERVER_MEMORY`, `PORT`, `ADMIN_USERNAME`, `ADMIN_PASSWORD`, `COOP_SERVER`, `NO_STEAM`, `DEBUG`

> 📚 **[View complete list of startup flags →](zomboid-server/env/docs/server-init-flags.md)**

### 2. Server Configuration Settings

**File**: `server-init-settings.sh`  
**Documentation**: [📖 server-init-settings.md](zomboid-server/env/docs/server-init-settings.md)

Controls gameplay mechanics, multiplayer features, and server behavior with 90+ variables:

```yaml
environment:
  - PVP=true
  - MAX_PLAYERS=64
  - PUBLIC=true
  - PUBLIC_NAME=My Zomboid Server
  - GLOBAL_CHAT=true
  - PASSWORD=mypassword
```

**Key variables**: `PVP`, `MAX_PLAYERS`, `PUBLIC`, `PUBLIC_NAME`, `GLOBAL_CHAT`, `VOICE_ENABLE`, `PASSWORD`, `RCON_PASSWORD`

> 📚 **[View complete list of server settings →](zomboid-server/env/docs/server-init-settings.md)**

### 3. Sandbox Variables

**File**: `server-sandbox-vars.sh`  
**Documentation**: [📖 server-sandbox-vars.md](zomboid-server/env/docs/server-sandbox-vars.md)

Controls world generation, zombie behavior, loot spawning, and survival mechanics with 100+ variables:

```yaml
environment:
  - ZOMBIES=3 # High population
  - SPEED=2 # Fast Shamblers
  - FOOD_LOOT=4 # Rare
  - XP_MULTIPLIER=1.5 # Faster progression
  - DAY_LENGTH=3 # 1 Hour
  - CAR_SPAWN_RATE=3 # Low
```

**Key variables**: `ZOMBIES`, `SPEED`, `STRENGTH`, `FOOD_LOOT`, `WEAPON_LOOT`, `XP_MULTIPLIER`, `DAY_LENGTH`, `CAR_SPAWN_RATE`

> 📚 **[View complete list of sandbox variables →](zomboid-server/env/docs/server-sandbox-vars.md)**

### Quick Setup Examples

**Hardcore Survival Server:**

```yaml
environment:
  - ZOMBIES=1 # Insane population
  - SPEED=1 # Sprinters
  - FOOD_LOOT=2 # Insanely rare
  - XP_MULTIPLIER=0.5 # Slower progression
  - PVP=true
  - MAX_PLAYERS=32
```

**Casual/Learning Server:**

```yaml
environment:
  - ZOMBIES=5 # Low population
  - SPEED=3 # Shamblers
  - FOOD_LOOT=6 # Common loot
  - XP_MULTIPLIER=2.0 # Faster progression
  - PVP=false
  - STARTER_KIT=true
```

## Server Management

This section covers all aspects of managing your Project Zomboid server, from connecting to it to monitoring logs and performing maintenance tasks.

### 1. 🔗 Connecting to Your Server

1. Launch Project Zomboid
2. Go to **Join Server** → **Direct Connection**
3. Enter your server's IP address and port (default: `16261`)
4. Enter password if required

### 2. 🖥️ Accessing Server Console

**Important**: The server console is **not available** through `docker attach zomboid-server`. The Project Zomboid server runs in the background without an interactive console interface.

To use the admin console, simply run:

```bash
docker exec -it zomboid-server admin-console
```

This command launches the admin console tool and connects you to your running server using the RCON protocol.

This command will:

- Connect to the Project Zomboid server using the RCON protocol
- Provide an interactive console for server administration
- Allow you to execute admin commands directly on the server

**RCON Connection Details:**

- **Protocol**: Remote Console (RCON) - industry standard for game server management
- **Authentication**: Uses the configured RCON password from your environment settings
- **Port**: Default RCON port is `27015` (configurable via `RCON_PORT`)
- **Security**: Encrypted connection for secure remote administration

**Common admin commands (available through RCON console):**

- `players` - List connected players
- `kickuser <username>` - Kick a player
- `banuser <username>` - Ban a player
- `unbanuser <username>` - Unban a player
- `adduser <username> <password>` - Add user account
- `grantadmin <username>` - Grant admin privileges
- `save` - Manually save the world
- `quit` - Shutdown server gracefully
- `help` - Show available commands

**Note**: Type `:q` or press `Ctrl+C` to exit the admin console.

### 3. 💾 Volumes and Data Management

The core server configuration and world data are stored under `/root/Zomboid` inside the container. This directory contains all your server settings, world saves, player data, and logs. By default, this data is persisted using a Docker volume to ensure it survives container restarts and updates.

It's highly recommended to use a bind mount (as shown in the docker-compose files above) to map this directory to a local path on your host system. This approach provides several benefits:

- **Easy access** to server files for backup and configuration
- **Better performance** compared to named volumes
- **Simplified data management** and migration between servers

### 4. 🔄 Server Updates

When you rebuild the Docker image, it will automatically download the latest stable version of Project Zomboid from SteamCMD and generate a new image with the updated game files. This ensures your server always runs the most recent stable release.

```bash
# Stop server
docker-compose down

# Rebuild with latest updates
docker-compose build --no-cache

# Start server
docker-compose up -d
```

## For Developers

### Development Environment Setup

1. **Install [VS Code](https://code.visualstudio.com/) and [Docker](https://www.docker.com/)**
2. **Install the VS Code "Remote - Containers" extension**
3. **Clone this repository**
4. **Open the repository in VS Code**
5. When prompted, click **"Reopen in Container"** or run the `Remote-Containers: Reopen in Container` command

The DevContainer includes all necessary development tools:

- Various linters and formatters (yamllint, shellcheck, hadolint, etc.)
- Git configuration and pre-commit hooks
- Shell utilities and debugging tools

### Code Quality Tools

a. Linting

```bash
npm run lint           # Run ESLint on JavaScript/JSON
npm run lint-fix       # Auto-fix ESLint issues
npm run ruff           # Run Ruff on Python code
npm run ruff-fix       # Auto-fix Ruff issues
```

b. Formatting

```bash
npm run format         # Format code with Prettier
```

### Contributing

1. **Fork the repository**
2. **Create a feature branch with a descriptive name:**

   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes following the code style guidelines**
4. **Run linting and formatting checks before committing:**

   ```bash
   npm run lint-fix
   npm run format
   ```

5. **Submit a pull request with a conventional commit title:**
   - Format: `<type>(<scope>): <subject>`
   - Valid types: `feat`, `fix`, `perf`, `refactor`, `revert`, `chore`, `ci`, `docs`
6. **Ensure all CI checks pass**

## License

This project is licensed under the terms specified in the [LICENSE](LICENSE) file.

## Support

- **Issues**: Report bugs and request features via [GitHub Issues](https://github.com/meshi-team/project-zomboid-server/issues)
- **Documentation**: Full documentation is available in the [docs](docs/) folder
