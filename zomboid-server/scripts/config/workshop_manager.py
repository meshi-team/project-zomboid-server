import os
import re
import shutil
import subprocess
from pathlib import Path

from utils import generate_symlink, setup_logger


class ProjectZomboidWorkshopManager:
    """Manage Project Zomboid Steam Workshop mods for a dedicated server.

    Responsibilities:
        - Read the selected Workshop item IDs (mods) from environment.
        - Detect which selected items are already downloaded in the Steam Workshop folder.
        - Download missing items (one-by-one) via `steamcmd`.
        - Synchronize symlinks under the server's workshop directory to point at downloaded items.

    Attributes:
        - server_app_id: Steam App ID for the dedicated server (default: 380870).
        - game_app_id: Steam App ID for the Zomboid game (default: 108600).
        - success_re: Regex to detect successful download messages from `steamcmd`.
        - error_re: Regex to detect error messages from `steamcmd`.
        - server_folder: Root folder of the dedicated server.
        - steam_workshop_folder: Resolved path to the Steam Workshop content for Zomboid.
        - server_workshop_folder: Resolved path to the server's workshop symlink directory.
        - server_workshop_items: Set of selected Workshop IDs (strings) from environment.

    """

    server_app_id = os.getenv("ZOMBOID_SERVER_APP_ID", "380870")
    game_app_id = os.getenv("ZOMBOID_GAME_APP_ID", "108600")

    server_version = os.getenv("PZ_VERSION", "failed-to-retreive")
    cache_dir = os.getenv("CACHE_DIR", "/root/Zomboid")
    defaults_dir = os.getenv("DEFAULTS_DIR", "/defaults")
    server_name = os.getenv("SERVER_NAME", "servertest")

    success_re = re.compile(r"Success.*item\s+(\d+)", re.IGNORECASE)
    error_re = re.compile(r"ERROR!.*item\s+(\d+)", re.IGNORECASE)

    def __init__(self, server_folder: str, steam_workshop_folder: str) -> None:
        """Initialize the manager with server and Steam Workshop paths.

        Args:
            server_folder: Root folder of the dedicated server.
            steam_workshop_folder: Root of the Steam Workshop installation
            -- (e.g., ~/.local/share/Steam/steamapps/workshop).

        """
        self.logger = setup_logger()
        self.server_folder = server_folder
        self.steam_workshop_folder = steam_workshop_folder
        self.steam_wk_game_folder = Path(self.steam_workshop_folder) / "content" / self.game_app_id
        self.server_workshop_folder = Path(server_folder) / "steamapps" / "workshop"
        self.server_wk_game_folder = self.server_workshop_folder / "content" / self.game_app_id
        self.server_workshop_items: set[str] = self.get_selected_workshop_items()
        self.active_mods: set[str] = self.get_selected_active_mods()
        self.maps = set()

    @staticmethod
    def get_selected_workshop_items() -> set[str]:
        """Read and normalize selected Workshop IDs from the `WORKSHOP_ITEMS` environment variable.

        The variable is expected to be a semicolon-separated list of numeric IDs.
        Empty segments and surrounding whitespace are ignored.

        Returns:
            A set of Workshop IDs (strings).

        """
        raw = os.getenv("WORKSHOP_ITEMS") or ""
        return {item.strip() for item in raw.split(";") if item.strip()}

    @staticmethod
    def get_selected_active_mods() -> set[str]:
        """Read and normalize selected active mods from the `MODS` environment variable.

        The variable is expected to be a semicolon-separated list of mod names.
        Empty segments and surrounding whitespace are ignored.

        Returns:
            A list of active mod names (strings).

        """
        raw = os.getenv("MODS") or ""
        return {item.strip() for item in raw.split(";") if item.strip()}

    def get_downloaded_workshop_items(self) -> set[str]:
        """Inspect the Steam Workshop folder to discover already downloaded items for the Zomboid game.

        Returns:
            A set of Workshop IDs (strings) that exist on disk under the resolved Workshop content path.

        """
        if not self.steam_wk_game_folder.is_dir():
            return set()
        return {p.name for p in self.steam_wk_game_folder.iterdir() if p.name.isdigit() and p.is_dir()}

    def download_workshop_items(self) -> None:
        """Download selected Workshop items one-by-one using `steamcmd`.

        Behavior:
            - Skips items already present on disk.
            - Items that show an error (or nonzero return code) are collected as failed and
              removed from `self.server_workshop_items` at the end.
        """
        downloaded = self.get_downloaded_workshop_items()
        succeeded: set[str] = set()
        failed: set[str] = set()

        for wid in self.server_workshop_items.copy():
            self.logger.info("-" * 40)
            self.logger.info("Processing workshop item: %s", wid)
            if wid in downloaded:
                self.logger.info("Already present, skipping: %s", wid)
                succeeded.add(wid)
                continue

            self.logger.info("Downloading: %s", wid)
            command = [
                "steamcmd",
                "+login",
                "anonymous",
                "+workshop_download_item",
                self.game_app_id,
                wid,
                "+quit",
            ]

            installation = subprocess.run(  # noqa: S603
                command,
                check=False,
                capture_output=True,
                text=True,
            )

            saw_success = any(self.success_re.search(line) for line in (installation.stdout or "").splitlines())
            saw_error = any(self.error_re.search(line) for line in (installation.stdout or "").splitlines())

            if saw_error or installation.returncode != 0:
                self.logger.error("Error reported during download of %s", wid)
                self.logger.error("%s will be removed from the workshop list", wid)
                failed.add(wid)

            if saw_success:
                self.logger.info("Download succeeded: %s", wid)
                succeeded.add(wid)

        self.logger.info("-" * 40)

        if failed:
            self.logger.warning(
                "Download summary → ok:%d, failed:%d (%s)",
                len(succeeded),
                len(failed),
                ", ".join(sorted(failed)),
            )
        else:
            self.logger.info("Download summary → ok:%d, failed:0", len(succeeded))

        self.server_workshop_items -= failed
        self.logger.info("-" * 40)

    def update_workshop_items_links(self) -> None:
        """Synchronize server workshop symlinks with the current selection.

        For each selected Workshop ID in `self.server_workshop_items`, ensure a symlink
        exists in `self.server_workshop_folder` pointing to the corresponding folder, that way
        it is easier to manage the mods from the server side.
        """
        desired: set[str] = set(self.server_workshop_items)
        self.server_wk_game_folder.mkdir(parents=True, exist_ok=True)

        # Discover existing symlinks in the server workshop folder
        current_links: set[str] = {p.name for p in self.server_wk_game_folder.iterdir() if p.is_symlink()}

        for name in sorted(current_links - desired):
            link_path = self.server_wk_game_folder / name
            try:
                link_path.unlink()
                self.logger.info("Removed stale workshop link: %s", name)
            except OSError as exc:
                self.logger.error("Failed to remove link %s: %s", name, exc)

        linked, errors = 0, 0
        for wid in sorted(desired):
            source_dir = self.steam_wk_game_folder / wid
            target_dir = self.server_wk_game_folder / wid
            if generate_symlink(source_dir, target_dir):
                linked += 1
                self.logger.info("Linked workshop item: %s", wid)
            else:
                errors += 1
                self.logger.error("Failed to link workshop item: %s", wid)

        self.logger.info("-" * 40)
        self.logger.info("Copying workshop manifest file.")
        manifest_file = f"appworkshop_{self.game_app_id}.acf"
        steam_wk_manifest = Path(self.steam_workshop_folder) / manifest_file
        server_wk_manifest = self.server_workshop_folder / manifest_file

        if len(desired) == 0 and server_wk_manifest.exists():
            self.logger.info("No workshop items selected, clearing manifest.")
            server_wk_manifest.unlink()
        else:
            shutil.copy2(steam_wk_manifest, server_wk_manifest)

        self.logger.info("-" * 40)
        self.logger.info("Linking summary → linked:%d, errors:%d", linked, errors)
        self.logger.info("-" * 40)

    def is_mod_active(self, mod_path: Path) -> bool:
        """Check if a mod path corresponds to an active mod.

        It reads the mod.info file to extract the mod ID and compares it to the
        list of active mods provided in the MODS environment variable.

        Args:
            mod_path (Path): Path to the mod directory.

        Returns:
            bool: True if the mod is active, False otherwise.

        """
        mod_info_file = mod_path / "mod.info"

        self.logger.info("-" * 40)
        self.logger.info("Checking if mod %s is active...", mod_path.name)
        if not mod_info_file.exists():
            self.logger.info("Mod %s has no mod.info file, cannot determine ID", mod_path.name)
            return False

        try:
            content = mod_info_file.read_text(encoding="utf-8-sig", errors="replace")
        except OSError as e:
            self.logger.error("Error reading mod.info for %s: %s", mod_path.name, e)
            return False

        id_re = re.compile(r"^\s*id\s*=\s*([^\r\n#;]+)", re.MULTILINE | re.IGNORECASE)
        match = id_re.search(content)

        if match:
            mod_id = match.group(1).strip()
            self.logger.info("Mod %s has ID: %s", mod_path.name, mod_id)
            is_active = mod_id in self.active_mods
            self.logger.info("Active: %s", is_active)
            return is_active

        return False

    def discover_workshop_maps(self) -> list[dict[str, str | None]]:
        """Discover maps from the currently linked workshop items.

        Iterates through each selected workshop item, checks active mods within them,
        and searches for map directories under 'media/maps/'. For each map found,
        records the map name and, if present, the path to the spawnpoints.lua file.

        Returns:
            A list of dictionaries, each containing:
            - 'map': The name of the map (str).
            - 'file': The relative path to the spawnpoints.lua file or None.

        """
        self.logger.info("Discovering maps in linked workshop items...")
        self.logger.info("-" * 40)

        maps = []

        # Builds the list of possible workshop paths to search for active mods
        wk_path_to_mods = [self.server_wk_game_folder / wid / "mods" for wid in self.server_workshop_items]

        # Collects all active mod folders across the possible workshop paths
        active_mod_folders = [
            mod_folder
            for path in wk_path_to_mods
            if path.is_dir()
            for mod_folder in path.iterdir()
            if mod_folder.is_dir() and self.is_mod_active(mod_folder)
        ]
        self.logger.info("-" * 40)

        maps_found = []  # To avoid duplicate map names across mods
        for active_mod in active_mod_folders:
            maps_count = 0
            self.logger.info("Scanning active mod: %s", active_mod.name)
            for map_path in active_mod.glob("**/media/maps/*"):
                if not map_path.is_dir() or map_path.name in maps_found:
                    self.logger.info("Skipping non-directory or duplicate map: %s", map_path.name)
                    continue

                maps_count += 1
                map_found = {"map": map_path.name}
                message = "  Found map: %s"
                spawnpoints_file = map_path / "spawnpoints.lua"

                if spawnpoints_file.exists():
                    message += " with spawnpoints"
                    map_found["file"] = f"media/maps/{map_path.name}/spawnpoints.lua"

                self.logger.info(message, map_path.name)
                maps.append(map_found)
                maps_found.append(map_path.name)

            if maps_count == 0:
                self.logger.info("No maps found in mod %s.", active_mod.name)

            self.logger.info("-" * 40)
        return maps

    def generate_spawnpoints_file(self, maps_info: list) -> None:
        """Generate the spawnregions.lua file based on discovered maps.

        Reads the default_spawnregions.lua template, inserts entries for each map
        found in `maps_info`, and writes the result to the server's spawnregions.lua file.

        Args:
            maps_info: List of dictionaries with 'map' and 'file' keys.

        Returns:
            None. The spawnregions.lua file is created or overwritten.

        """
        if not maps_info:
            self.logger.info("No maps to process for spawnregions generation.")
            return

        default_path = Path(self.defaults_dir) / "default_spawnregions.lua"
        spawnregions_path = Path(self.cache_dir) / "Server" / f"{self.server_name}_spawnregions.lua"

        content = default_path.read_text(encoding="utf-8")

        to_add = []

        # Iterate over the maps info and look for the ones with a 'file' entry
        # the file entry has the relative path to the spawnpoints.lua file
        for rec in maps_info:
            name = rec.get("map", "").strip()
            file_path = rec.get("file")

            if not name or not file_path:
                continue

            to_add.append((name, str(file_path)))

        # If none of the maps have a 'file' entry, skip generation
        if not to_add:
            self.logger.info("No valid maps with 'file' found.")
            return

        lines = content.splitlines()
        close_idx = None

        # Find the index of the closing brace of the main table
        # starting from the end of the file.
        for i in range(len(lines) - 1, -1, -1):
            if lines[i].strip() == "}":
                close_idx = i
                break

        if close_idx is None:
            self.logger.error("Invalid default_spawnregions.lua: table closing brace not found.")
            return

        # Try to preserve indentation from existing rows, fallback to 8 spaces
        m_indent = re.search(r'(?m)^(\s*)\{\s*name\s*=\s*"', content)
        indent = m_indent.group(1) if m_indent else "        "

        new_rows = [f'{indent}{{ name = "{name}", file = "{file_str}" }},' for name, file_str in to_add]

        new_lines = lines[:close_idx] + new_rows + lines[close_idx:]
        new_content = "\n".join(new_lines) + ("\n" if content.endswith("\n") else "")

        # Write the new content to the spawnregions.lua file
        spawnregions_path.parent.mkdir(parents=True, exist_ok=True)
        spawnregions_path.write_text(new_content, encoding="utf-8")

        self.logger.info(
            "Generated %s with %d appended spawnregion(s).",
            spawnregions_path,
            len(new_rows),
        )

    def process_workshop_items(self) -> None:
        """Process the entire workshop items routine: download and link."""
        self.download_workshop_items()
        self.update_workshop_items_links()

        maps_info = self.discover_workshop_maps()
        self.maps = {rec["map"] for rec in maps_info if "map" in rec}

        self.generate_spawnpoints_file(maps_info)

    def get_maps_string(self) -> str:
        """Get the discovered maps as a semicolon-separated string.

        It always starts with "Muldraugh, KY" as the default map. If no maps
        were discovered, it returns just the default map.
        """
        last_map = "Muldraugh, KY"
        maps_str = ";".join(sorted(self.maps))

        return f"{maps_str};{last_map}" if maps_str else last_map
