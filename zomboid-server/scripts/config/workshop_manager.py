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

        self.logger.info("Copying workshop manifest file.")
        manifest_file = f"appworkshop_{self.game_app_id}.acf"
        steam_wk_manifest = Path(self.steam_workshop_folder) / manifest_file
        server_wk_manifest = self.server_workshop_folder / manifest_file

        if len(desired) == 0 and server_wk_manifest.exists():
            self.logger.info("No workshop items selected, clearing manifest.")
            server_wk_manifest.unlink()
        else:
            shutil.copy2(steam_wk_manifest, server_wk_manifest)

        self.logger.info("Linking summary → linked:%d, errors:%d", linked, errors)
        self.logger.info("-" * 40)

    def process_workshop_items(self) -> None:
        """Process the entire workshop items routine: download and link."""
        self.download_workshop_items()
        self.update_workshop_items_links()
