# Project Zomboid Dedicated Server

Docker image for running a **Project Zomboid** dedicated server. Fully configurable via environment variables, with built-in Steam Workshop support, automatic map integration, and an RCON-powered admin console.

- **Source**: https://github.com/meshi-team/project-zomboid-server
- **Full documentation**: [README on GitHub](https://github.com/meshi-team/project-zomboid-server#readme)
- **Issues**: https://github.com/meshi-team/project-zomboid-server/issues

## Quick start

### docker run

```bash
docker run -d \
  --name zomboid-server \
  -p 16261:16261/udp \
  -p 16262:16262/udp \
  -v $(pwd)/data:/root/Zomboid \
  -v $(pwd)/workshop:/root/.local/share/Steam/steamapps/workshop \
  -e SERVER_NAME=MyServer \
  -e ADMIN_PASSWORD=change-me \
  m4lagon/project-zomboid-server:latest
```

### docker compose

```yaml
services:
  zomboid-server:
    image: m4lagon/project-zomboid-server:latest
    container_name: zomboid-server
    ports:
      - 16261:16261/udp
      - 16262:16262/udp
      - 27015:27015   # optional, for external RCON
    volumes:
      - ./data:/root/Zomboid
      - ./workshop:/root/.local/share/Steam/steamapps/workshop
    environment:
      - SERVER_NAME=MyServer
      - ADMIN_PASSWORD=change-me
```

Then connect in-game to `localhost:16261`.

## Image tags

| Tag | Meaning |
|---|---|
| `latest` | Latest published build — bleeding edge |
| `x.y.z` (e.g. `41.78.19`) | Pinned to the Project Zomboid server semver at build time |

Pin to `x.y.z` for predictable production deployments. Use `latest` for hobby servers.

## Configuration

The server is configured entirely via environment variables — three groups:

1. **Startup options** — memory, ports, Steam toggles, presets. [Full list](https://github.com/meshi-team/project-zomboid-server/blob/main/docs/server_customization/1-server-base-variables-and-flags.md)
2. **Server config** — multiplayer, RCON, map, PvP, player limits. [Full list](https://github.com/meshi-team/project-zomboid-server/blob/main/docs/server_customization/2-server-general-config.md)
3. **Sandbox variables** — zombies, loot, XP, day length, car spawns. [Full list](https://github.com/meshi-team/project-zomboid-server/blob/main/docs/server_customization/3-server-sandbox-vars.md)

### Most common variables

```yaml
# Server
SERVER_NAME=MyServer
ADMIN_USERNAME=admin
ADMIN_PASSWORD=change-me
SERVER_MEMORY=4096m
PUBLIC=true
MAX_PLAYERS=32

# World
ZOMBIES=3
DAY_LENGTH=3
PVP=false
XP_MULTIPLIER=1.5
```

### Presets

Apply a PZ preset via `SERVER_PRESET` (Apocalypse, Beginner, Builder, FirstWeek, Survival, Survivor, SixMonthsLater, SandboxVars). Combine with `FORCE_PRESET=1` on the first run to fully regenerate the config:

```yaml
environment:
  - SERVER_PRESET=Survival
  - FORCE_PRESET=1
```

## Volumes

- `/root/Zomboid` — world saves, server config, logs, player DB.
- `/root/.local/share/Steam/steamapps/workshop` — downloaded Workshop content.

Bind-mount both for persistence across container recreations.

## Ports

| Port | Protocol | Purpose |
|---|---|---|
| `16261` | UDP | Main server / Steam connection |
| `16262` | UDP | Player communication |
| `27015` | TCP | RCON (optional, if you want external admin) |

## Steam Workshop & mods

Two environment variables drive Workshop integration:

```yaml
environment:
  - WORKSHOP_ITEMS=1234567890;9876543210    # Workshop IDs to download
  - MODS=CoolMod;MapMod                      # Mod IDs to enable (from mod.info)
```

Map-adding mods are auto-integrated: the `MAP` variable and `spawnregions.lua` are updated automatically. Clients must subscribe to the same mods to join.

## Admin console

```bash
docker exec -it zomboid-server admin-console
```

Common commands: `players`, `kickuser`, `banuser`, `grantadmin`, `save`, `quit`, `help`.

## Image metadata

This image publishes [OCI image labels](https://github.com/opencontainers/image-spec/blob/main/annotations.md) including `org.opencontainers.image.version` (PZ semver) and `com.projectzomboid.buildId` (Steam buildid). Inspect with:

```bash
docker inspect m4lagon/project-zomboid-server:latest \
  --format '{{json .Config.Labels}}' | jq
```

## License

MIT — see [LICENSE](https://github.com/meshi-team/project-zomboid-server/blob/main/LICENSE).
