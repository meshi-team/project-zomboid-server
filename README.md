# Project Zomboid Server

This repository provides a **Docker-based setup** for running a Project Zomboid dedicated server with advanced configuration options.
It’s designed to be **easy to deploy**, **simple to customize**, and **ready for mods and workshop content** right out of the box.

<!-- markdownlint-disable MD051 -->
<!-- markdownlint-disable MD033 -->

## Index

- [✨ Features](#features)
- [📦 Requirements](#requirements)
- [🚀 How to Run](#how-to-run)
- [⚙️ Configuration](#configuration)
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

  - `16261` (UDP/TCP) – main server port
  - `8766` (UDP) – Steam query port
  - `16262–16272` (UDP) – direct connection ports

- **Steam account** (optional, for Steam integration features)

---

## 🚀 How to Run <a id="how-to-run"></a>

You can either use our **ready-to-use image** or **build from source**.

### Option 1: Ready-to-Use Image (Work in Progress) 🚧

Note: The prebuilt image is work-in-progress; image tags and behavior may change while we finalize publishing.

Pull the prebuilt image from GitHub Container Registry:

```bash
docker pull ghcr.io/meshi-team/zomboid-server:latest
```

The easiest way to run is with **docker-compose**:

```yaml
services:
  zomboid-server:
    container_name: zomboid-server
    image: ghcr.io/meshi-team/zomboid-server:latest
    volumes:
      - ./data:/root/Zomboid
      - ./workshop:/root/.local/share/Steam/steamapps/workshop
    ports:
      - 16261:16261/udp
      - 16261:16261/tcp
      - 8766:8766/udp
      - 16262-16272:16262-16272/udp
    environment:
      - SERVER_NAME=MyServer
      - ADMIN_PASSWORD=secret
```

Or directly with `docker run`:

```bash
docker run -d \
  --name zomboid-server \
  -p 16261:16261/udp -p 16261:16261/tcp \
  -p 8766:8766/udp \
  -p 16262-16272:16262-16272/udp \
  -v ./data:/root/Zomboid \
  -e SERVER_NAME=MyServer \
  -e ADMIN_PASSWORD=secret \
  ghcr.io/meshi-team/zomboid-server:latest
```

<!-- markdownlint-disable MD051 -->

You can customize the server by adding more environment variables (see [Configuration](#configuration) below).

### Option 2: Build from Source

Clone the repository and adjust your compose file:

```bash
git clone https://github.com/meshi-team/project-zomboid-server.git
cd project-zomboid-server
```

<!-- markdownlint-disable MD051 -->

Edit `docker-compose.yml` as needed (see [Configuration](#configuration) below) and then run:

```bash
docker-compose up -d
```

---

## ⚙️ Configuration <a id="configuration"></a>

The server has **three configurable parts**. All of them can be customized with environment variables – no manual file editing required.

### 1. Startup Options (Flags)

- Memory, ports, Steam/no-Steam, debug mode, etc.

- Full reference: [1-server-base-variables-and-flags.md](docs/server_customization/1-server-base-variables-and-flags.md)

- Example:

  ```yaml
  environment:
    - SERVER_NAME=MyServer
    - SERVER_MEMORY=4096m
    - PORT=16261
    - ADMIN_PASSWORD=MyPass
  ```

### 2. Server Configuration (`servertest.ini`)

- Multiplayer features, server rules, player limits, RCON, etc.

- Full reference: [2-server-general-config.md](docs/server_customization/2-server-general-config.md)

- Example:

  ```yaml
  environment:
    - MAX_PLAYERS=64
    - PUBLIC=true
    - PVP=true
    - RCON_PASSWORD=RconSecret
  ```

### 3. Sandbox Variables (`SandboxVars.lua`)

- World settings: zombies, loot, XP rates, car spawns, day length, etc.

- Full reference: [3-server-sandbox-vars.md](docs/server_customization/3-server-sandbox-vars.md)

- Example:

  ```yaml
  environment:
    - ZOMBIES=3
    - SPEED=2
    - FOOD_LOOT=4
    - XP_MULTIPLIER=1.5
    - DAY_LENGTH=3
  ```

#### Presets and FORCE_PRESET

- `SERVER_PRESET=<name>`: Use a SandboxVars preset file (e.g., `<name>.lua` in your configured presets directory) as the base when creating or refreshing `SandboxVars.lua`.
- By default, if a SandboxVars already exists in your data folder, it is used as the base and your environment variables override specific keys.
- Set `FORCE_PRESET=1` to replace any existing `SandboxVars.lua` with the selected preset on startup; your environment variables are then applied on top of that preset.
- If the preset file isn’t found, the default Sandbox template is used and a warning is logged.

---

### Quick Setup Examples

**Hardcore survival server:**

```yaml
environment:
  - ZOMBIES=1
  - SPEED=1
  - FOOD_LOOT=2
  - XP_MULTIPLIER=0.5
  - PVP=true
  - MAX_PLAYERS=32
```

**Casual learning server:**

```yaml
environment:
  - ZOMBIES=5
  - SPEED=3
  - FOOD_LOOT=6
  - XP_MULTIPLIER=2.0
  - PVP=false
  - STARTER_KIT=true
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

## 🧩 Modding <a id="modding"></a>

The server makes modding easy – most of the setup is automated.
You only need to declare two environment variables:

- **`WORKSHOP_ITEMS`** → list of Workshop IDs
- **`MODS`** → list of Mod IDs (as they appear in `mod.info`)

Both are **semicolon-separated**.

Example:

```yaml
environment:
  - WORKSHOP_ITEMS=123456789;987654321
  - MODS=MyCoolMod;AnotherMod
```

> [!NOTE]
> The container downloads Workshop content into Steam’s shared Workshop cache (default: `/root/.local/share/Steam/steamapps/workshop`).
> Your bind‑mounted workshop folder may therefore contain many mods once downloaded, but only the mods you list in `MODS` are linked into the server and actually loaded. You don’t need to manage that folder manually—selection is controlled by `WORKSHOP_ITEMS` (what to download) and `MODS` (what to load).

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

- Automatically generate the `MAP` variable (there is no single “correct” order)
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
