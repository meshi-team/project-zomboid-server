# Project Zomboid Server

This repository provides a **Docker-based setup** for running a Project Zomboid dedicated server with advanced configuration options.
It’s designed to be **easy to deploy**, **simple to customize**, and **ready for mods and workshop content** right out of the box.

<!-- markdownlint-disable MD051 -->
<!-- markdownlint-disable MD033 -->

## Index

- [✨ Features](#features)
- [📦 Requirements](#requirements)
- [🚀 How to Run](#how-to-run)
- [⚙️ Environment variables](#environment-variables)
- [🖥️ Server Management](#server-management)
- [💾 Volumes & Data](#volumes--data)
- [🧩 Modding](#modding)
- [📖 Documentation](#documentation)
- [👩‍💻 For Developers](#for-developers)
- [📜 License](#license)

---

## ✨ Features <a id="features"></a>

- 🐳 **Docker-based deployment** – clean and portable setup
- 🔧 **Full environment-based configuration** – everything is controlled with env vars
- 🎮 **Built-in admin console** – manage your server through an RCON-powered CLI
- 🧩 **Workshop & mod support** – automatic mod and map integration

---

## 📦 Requirements <a id="requirements"></a>

- **Docker** and **Docker Compose** installed
- **4 GB+ RAM** recommended (configurable via `SERVER_MEMORY`)
- **Open ports** for communication:

  Required:

  - `16261` (UDP) – main server port
  - `16262` (UDP) – first player connection port

  Optional:

  - `27015` (TCP) – RCON (remote console)

- **Steam account** (optional, for Steam integration features)

---

## 🚀 How to Run <a id="how-to-run"></a>

Follow these simple steps to get a server running quickly with Docker. You can use either Docker Compose (recommended) or a single docker run command.

### 1) Pull the image

```bash
docker pull ghcr.io/meshi-team/zomboid-server:latest
```

### 2) Create a minimal docker-compose.yml

Create a file named `docker-compose.yml` in an empty folder and paste this minimal example:

```yaml
services:
  zomboid-server:
    image: ghcr.io/meshi-team/zomboid-server:latest
    container_name: zomboid-server
    ports:
      - 16261:16261/udp
      - 16262:16262/udp
    volumes:
      - ./data:/root/Zomboid # persist saves/configs/logs
      - ./workshop:/root/.local/share/Steam/steamapps/workshop # persist workshop mods
    environment:
      - SERVER_NAME=MyServer
      - ADMIN_PASSWORD=secret
      # Check the full list of variables below
```

### 3) Start the server

```bash
docker compose up
```

Connect from the game client to: `your-server-ip:16261`.

---

### Alternative: Run without Compose

Use a single command instead of a compose file:

```bash
docker run -d \
  --name zomboid-server \
  -p 16261:16261/udp \
  -p 16262:16262/udp \
  -v "$(pwd)"/data:/root/Zomboid \
  -e SERVER_NAME=MyServer \
  -e ADMIN_PASSWORD=secret \
  ghcr.io/meshi-team/zomboid-server:latest
```

To persist Workshop downloads as well, add:

```bash
-v "$(pwd)"/workshop:/root/.local/share/Steam/steamapps/workshop \
```

---

## ⚙️ Environment variables <a id="environment-variables"></a>

The server has **three configurable parts**. All of them can be customized with environment variables – no manual file editing required.

### 1. Startup Options

- Memory, ports, Steam/no-Steam, debug mode, etc.

- Full list: [1-server-base-variables-and-flags.md](docs/server_customization/1-server-base-variables-and-flags.md)

- Example (set as environment variables):

  ```bash
  # Check out the full list at the link above
  SERVER_NAME=MyServer
  SERVER_MEMORY=4096m
  PORT=16261
  ADMIN_PASSWORD=MyPass
  ADMIN_USERNAME=admin
  NO_STEAM=0
  DEBUG=0
  SERVER_PRESET=FirstDay
  ```

### 2. Server Configuration

- Multiplayer features, server rules, player limits, RCON, etc.

- Full list: [2-server-general-config.md](docs/server_customization/2-server-general-config.md)

- Example (set as environment variables):

  ```bash
  # Check out the full list at the link above
  PUBLIC=true
  PUBLIC_NAME="My PZ Server"
  MAX_PLAYERS=64
  PVP=true
  PASSWORD=
  RCON_PASSWORD=RconSecret
  RCON_PORT=27015
  MAP="Muldraugh, KY"
  ```

### 3. Sandbox Variables

- World settings: zombies, loot, XP rates, car spawns, day length, etc.

- Full list: [3-server-sandbox-vars.md](docs/server_customization/3-server-sandbox-vars.md)

- Example (set as environment variables):

  ```bash
  # Check out the full list at the link above
  ZOMBIES=3
  SPEED=2
  FOOD_LOOT=4
  XP_MULTIPLIER=1.5
  DAY_LENGTH=3
  STARTER_KIT=true
  CAR_SPAWN_RATE=3
  ```

#### Applying a preset

- `SERVER_PRESET=<name>` selects a predefined preset by name and applies its configuration at startup.
- By default, if a configuration already exists in your data folder, the existing configuration is kept and your environment variables override individual settings as needed.
- Set `FORCE_PRESET=1` to fully apply the selected preset on startup, replacing any existing configuration; your environment variables are then applied on top.
- If the preset name isn’t found, a default template is used and a warning is logged.

Example:

```bash
SERVER_PRESET=FirstDay
FORCE_PRESET=1
```

Tip: Use `FORCE_PRESET=1` only for the run where you want to reapply the preset, then remove it so your configuration isn’t replaced on every restart.

Available presets:

- Apocalypse
- Beginner
- Builder
- FirstWeek
- SandboxVars
- SixMonthsLater
- Survival
- Survivor

Learn more about these modes: [PZ Wiki – Game modes](https://pzwiki.net/wiki/Game_modes)

---

### Quick Setup Examples

**Hardcore survival server:**

```bash
ZOMBIES=1
SPEED=1
FOOD_LOOT=2
XP_MULTIPLIER=0.5
PVP=true
MAX_PLAYERS=32
```

**Casual learning server:**

```bash
ZOMBIES=5
SPEED=3
FOOD_LOOT=6
XP_MULTIPLIER=2.0
PVP=false
STARTER_KIT=true
```

---

## 🖥️ Server Management <a id="server-management"></a>

- **Connect to server** – Direct connect in-game to `IP:16261`
- **Access console** – Use the built-in RCON console:

  ```bash
  docker exec -it zomboid-server admin-console
  ```

- **Common commands:** `players`, `kickuser`, `banuser`, `grantadmin`, `save`, `quit`, `help`

---

## 💾 Volumes & Data <a id="volumes--data"></a>

Two important volumes are defined by default:

- **`data` → `/root/Zomboid`**
  Stores world saves, configs, logs, and player data

- **Workshop dir** (Steam default: `/root/.local/share/Steam/steamapps/workshop`)
  Stores downloaded Workshop content

Bind-mount these directories on your host for backups and migrations.

---

## 🧩 Modding

The server supports downloading and enabling mods/maps via Steam Workshop. Two key environment variables control this:

- `WORKSHOP_ITEMS` — list of Workshop item IDs. These are numeric IDs from Steam Workshop; the server uses this list to download the required content automatically.
- `MODS` — list of Mod IDs. Only mods whose IDs are listed here will be loaded by the server (even if their Workshop items were downloaded).

### Example

```yaml
environment:
  - WORKSHOP_ITEMS=1234567890;9876543210 # IDs of Workshop items to download
  - MODS=CoolMod;ExtraMapMod # Mod IDs (from mod.info) to load
```

> [!NOTE]
> The container downloads Workshop content into Steam’s shared Workshop cache (default: `/root/.local/share/Steam/steamapps/workshop`).
> Your bind‑mounted workshop folder may therefore contain many mods once downloaded, but only the workshop ids and mods you list in the environment variables are the ones loaded.

On startup, the server will:

- Download missing Workshop items
- Enable the mods automatically
- Keep them in sync for next launches

⚠️ **Note**: Mods must be downloaded and enabled on the **client** side as well for players to join.

Where to find IDs

- Workshop ID: visible in the Steam Workshop item URL (the trailing numeric id), and on the item page.
- Mod ID: shown on the Workshop page (often under “Mod ID”), and always inside the mod’s `mod.info` file.

### 🗺️ Auto Maps Support

If any installed mod includes **maps**, the server will:

- Automatically generate the `MAP` variable.
- Update your server configuration
- Patch your `spawnregions.lua` with valid spawnpoints

If you want to override the map load order, set the `MAP` variable manually. This should only be necessary when map compatibility requires it. Feel free to declare your own map string as in the example below. Note: `Muldraugh, KY` should be last.

```yaml
environment:
  - MAP=BedfordFalls;West Point, KY;Muldraugh, KY
```

---

## 📖 Documentation <a id="documentation"></a>

The project's documentation is evolving as new features are released. Inside the [docs folder](docs/), you’ll find:

- How the container and helper scripts are implemented (entrypoint, configuration pipeline, utilities)
- How Workshop mods are downloaded, enabled, and kept in sync
- Automatic maps handling (detection, load-order overrides when needed, spawn regions patching)
- How environment variables override server INI and SandboxVars before startup

Start here: [Documentation Overview](docs/README.md)

---

## 👩‍💻 For Developers <a id="for-developers"></a>

We include a **DevContainer** and a set of tools for contributors:

- **Linting & formatting**: ESLint, Prettier, Ruff, ShellCheck, Hadolint
- **Pre-commit hooks**
- **VS Code Remote Containers** ready

### Development Setup

1. Clone repo
2. Open in VS Code
3. Reopen in container → ready to hack

---

## 📜 License <a id="license"></a>

This project is licensed under the terms in [LICENSE](LICENSE).
