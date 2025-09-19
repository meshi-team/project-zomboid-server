# Project Zomboid Server

This repository provides a **Docker-based setup** for running a Project Zomboid dedicated server with advanced configuration options.
It’s designed to be **easy to deploy**, **simple to customize**, and **ready for mods and workshop content** right out of the box.

---

## ✨ Features

* 🐳 **Docker-based deployment** – clean and portable setup
* 🔧 **Full environment-based configuration** – everything is controlled with env vars
* 🎮 **Built-in admin console** – manage your server through an RCON-powered CLI
* 🧩 **Workshop & mod support** – automatic mod and map integration

---

## 📦 Requirements

* **Docker** and **Docker Compose** installed
* **4 GB+ RAM** recommended (configurable via `SERVER_MEMORY`)
* **Open ports** for communication:

  * `16261` (UDP/TCP) – main server port
  * `8766` (UDP) – Steam query port
  * `16262–16272` (UDP) – direct connection ports
* **Steam account** (optional, for Steam integration features)

---

## 🚀 How to Run

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

### Option 2: Build from Source

Clone the repository and adjust your compose file:

```bash
git clone https://github.com/meshi-team/project-zomboid-server.git
cd project-zomboid-server
```

Edit `docker-compose.yml` as needed (see [Configuration](#configuration) below) and then run:

```bash
docker-compose up -d
```

---

## ⚙️ Configuration

The server has **three configurable parts**. All of them can be customized with environment variables – no manual file editing required.

1. **Startup options (flags)**

   * Memory, ports, Steam/no-Steam, debug mode, etc.
   * Example:

     ```yaml
     environment:
       - SERVER_NAME=MyServer
       - SERVER_MEMORY=4096m
       - PORT=16261
       - ADMIN_PASSWORD=MyPass
     ```

2. **Server configuration (`servertest.ini`)**

   * Multiplayer features, server rules, player limits, RCON, etc.
   * Example:

     ```yaml
     environment:
       - MAX_PLAYERS=64
       - PUBLIC=true
       - PVP=true
       - RCON_PASSWORD=RconSecret
     ```

3. **Sandbox variables (`SandboxVars.lua`)**

   * World settings: zombies, loot, XP rates, car spawns, day length, etc.
   * Example:

     ```yaml
     environment:
       - ZOMBIES=3
       - SPEED=2
       - FOOD_LOOT=4
       - XP_MULTIPLIER=1.5
       - DAY_LENGTH=3
     ```

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

## 🖥️ Server Management

* **Connect to server** – Direct connect in-game to `IP:16261`
* **Access console** – Use the built-in RCON console:

  ```bash
  docker exec -it zomboid-server admin-console
  ```

* **Common commands:** `players`, `kickuser`, `banuser`, `grantadmin`, `save`, `quit`, `help`

---

## 💾 Volumes & Data

Two important volumes are defined by default:

* **`data` → `/root/Zomboid`**
  Stores world saves, configs, logs, and player data

* **Workshop dir** (Steam default: `/root/.local/share/Steam/steamapps/workshop`)
  Stores downloaded Workshop content

Bind-mount these directories on your host for backups and migrations.

---

## 🧩 Modding

The server makes modding easy – most of the setup is automated.
You only need to declare two environment variables:

* **`WORKSHOP_ITEMS`** → list of Workshop IDs
* **`MODS`** → list of Mod IDs (as they appear in `mod.info`)

Both are **semicolon-separated**.

Example:

```yaml
environment:
  - WORKSHOP_ITEMS=123456789;987654321
  - MODS=MyCoolMod;AnotherMod
```

On startup, the server will:

* Download missing Workshop items
* Enable the mods automatically
* Keep them in sync for next launches

⚠️ **Note**: Mods must be downloaded and enabled on the **client** side as well for players to join.

Where to find IDs

* Workshop ID: visible in the Steam Workshop item URL (the trailing numeric id), and on the item page.
* Mod ID: shown on the Workshop page (often under “Mod ID”), and always inside the mod’s `mod.info` file.

### 🗺️ Auto Maps Support

If any installed mod includes **maps**, the server will:

* Automatically generate the `MAP` variable (there is no single “correct” order)
* Update your server configuration
* Patch your `spawnregions.lua` with valid spawnpoints

If you want to override the map load order, set the `MAP` variable manually. This should only be necessary when map compatibility requires it. Feel free to declare your own map string as in the example below. Note: `Muldraugh, KY` should be last.

```yaml
environment:
  - MAP=BedfordFalls;West Point, KY;Muldraugh, KY
```

---

## 👩‍💻 For Developers

We include a **DevContainer** and a set of tools for contributors:

* **Linting & formatting**: ESLint, Prettier, Ruff, ShellCheck, Hadolint
* **Pre-commit hooks**
* **VS Code Remote Containers** ready

### Development Setup

1. Clone repo
2. Open in VS Code
3. Reopen in container → ready to hack

---

## 📜 License

This project is licensed under the terms in [LICENSE](LICENSE).

---

## 🆘 Support

* Issues → [GitHub Issues](https://github.com/meshi-team/project-zomboid-server/issues)
* Docs → this README and inline examples
