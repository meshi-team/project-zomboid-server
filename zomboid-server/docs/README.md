# Project Zomboid Server – Documentation

Welcome! This documentation is your companion to running and customizing the Project Zomboid server in this repository. It focuses on two areas:

- How the server works under the hood (downloads, mounts, and automations)
- How to customize the server using environment variables

Whether you want to understand the internals or just tweak settings confidently, you’re in the right place.

---

## 📚 Documentation Structure

### 1) how_does_it_work/

Deep dives into the implementation details, including:

- Workshop mods flow: how items are discovered, downloaded via SteamCMD, cached, and linked into the server
- Automatic wiring: enabling mods, generating map lists, and updating spawn regions
- Configuration pipeline: when and how the server’s INI and SandboxVars are created/validated and updated before startup
- Built-in admin console: how it works, installation of the RCON library, and usage instructions

Use this section when you want to understand the “why” and “how” behind the automation.

- Start with: [1) Image build and defaults](how_does_it_work/1-image-build-and-defaults.md)

### 2) server_customization/

Everything you can configure using environment variables:

- Startup flags and base variables (memory, ports, Steam/No-Steam, debug, admin credentials)
- Server configuration (ini) options and common gameplay settings
- Sandbox variables (world rules, zombies, loot, progression)
- How variable replacement works and what gets applied where

Use this section when you want to change behavior without editing files.

---

## 🚀 Quick Start

If you’re here to customize your server quickly:

1. Skim through `server_customization/` for the list of available environment variables.
2. Add your changes under the `environment:` section in your docker-compose file (or pass with `-e` in `docker run`).
3. Recreate the container so changes apply at startup.

For a deeper grasp of what happens during startup—mods, maps, and config generation—read `how_does_it_work/`.

---

## 🔗 Where to go next

- Implementation details → `how_does_it_work/`
- Environment variables and config → `server_customization/`

If something’s unclear or you spot an opportunity to improve this documentation, feel free to open an issue or PR. Happy surviving!
