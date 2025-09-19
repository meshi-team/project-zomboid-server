"""Server configuration manager for Project Zomboid.

Provides a class-based API to validate/create server config files (INI and
SandboxVars) and to replace variables in those files based on an environment
mapping. Mirrors the style and responsibilities of the workshop manager.
"""

import re
from pathlib import Path

from utils import REGEX, convert_to_flatcase, is_line_valid, setup_logger


class ProjectZomboidServerManager:
    """Manage Project Zomboid server configuration files and replacements.

    Responsibilities:
        - Validate or create the main server configuration file (.ini).
        - Validate or create the SandboxVars.lua using defaults or presets.
        - Optionally force a preset even when a sandbox file already exists.
        - Replace variables in configuration files using values from the environment.

    Attributes:
        - env: Mapping of configuration/environment variables used by the manager.
        - logger: Configured logger instance for informational messages.

    """

    def __init__(self, env: dict) -> None:
        """Initialize the server manager with an environment mapping.

        Extracts commonly used values to attributes to avoid passing them
        around repeatedly.
        """
        self.env = dict(env)
        self.logger = setup_logger()
        self.server_name = self.env.get("SERVER_NAME", "servertest")
        self.cache_dir = self.env.get("CACHE_DIR", "/root/Zomboid")
        self.defaults_dir = self.env.get("DEFAULTS_DIR", "/defaults")
        self.presets_dir = self.env.get("PRESETS_DIR", "")
        self.selected_preset = self.env.get("SERVER_PRESET")
        self.force_preset = self.env.get("FORCE_PRESET", "0") == "1"

    def validate_config_file(self) -> str:
        """Ensure the server INI file exists and return its path.

        Behavior:
            - Builds the path as {CACHE_DIR}/Server/{server_name}.ini (/root/Zomboid by default).
            - If missing, copies {DEFAULTS_DIR}/default.ini (/defaults by default) to that path.

        Returns:
            The full path to the server's .ini file.

        """
        default_file = f"{self.defaults_dir}/default.ini"
        config_file = f"{self.cache_dir}/Server/{self.server_name}.ini"
        self.logger.info("Validating config file for server: %s", self.server_name)

        if not Path(config_file).exists():
            self.logger.info("Config file missing, creating from default")
            default_path = Path(default_file)
            Path(config_file).parent.mkdir(parents=True, exist_ok=True)
            Path(config_file).write_text(
                default_path.read_text(encoding="utf-8"),
                encoding="utf-8",
            )
        else:
            self.logger.info("Config file exists, using it as is")

        self.logger.info("-" * 40)
        return config_file

    def validate_sandbox_file(self) -> str:
        """Validate or create the server SandboxVars.lua and return its path.

        Selection logic:
            - If SERVER_PRESET is set and the file exists in PRESETS_DIR, it's used as source.
            - If sandbox already exists, it's used as the base; when FORCE_PRESET=1, the preset overrides it.
            - Otherwise, uses {DEFAULTS_DIR}/default_SandboxVars.lua.

        The selected content is normalized by replacing a leading "return" with "SandboxVars =" and is
        written to {CACHE_DIR}/Server/{server_name}_SandboxVars.lua.

        Returns:
            The full path to the resulting SandboxVars.lua.

        Raises:
            OSError: If reading from or writing to files fails.

        """
        default_file = f"{self.defaults_dir}/default_SandboxVars.lua"
        sandbox_file = f"{self.cache_dir}/Server/{self.server_name}_SandboxVars.lua"

        preset_file = (
            f"{self.presets_dir}/{self.selected_preset}.lua"
            if self.selected_preset
            else None
        )
        self.logger.info("-" * 40)
        self.logger.info("Validating SandboxVars for server: %s", self.server_name)
        if preset_file and not Path(preset_file).exists():
            preset_file = None
            self.logger.warning(
                'Preset "%s" doesn\'t exist, skipping', self.selected_preset,
            )

        if not Path(sandbox_file).exists():
            self.logger.info(
                'SandboxVars file missing, creating from "%s"', preset_file or "default",
            )
            default_path = Path(preset_file) if preset_file else Path(default_file)
        else:
            self.logger.info(
                "SandboxVars file exists, using it as base %s",
                " (forcing preset)" if self.force_preset else "",
            )
            default_path = Path(sandbox_file)
            if preset_file and self.force_preset:
                self.logger.info('Forcing preset "%s"', self.selected_preset)
                default_path = Path(preset_file)

        default_content = default_path.read_text(encoding="utf-8").replace(
            "return",
            "SandboxVars =",
        )
        Path(sandbox_file).parent.mkdir(parents=True, exist_ok=True)
        Path(sandbox_file).write_text(default_content, encoding="utf-8")

        self.logger.info("-" * 40)
        return sandbox_file

    def replace_file_variables(self, file_path: str) -> None:
        """Replace variables in a config file with values from a mapping.

        Matching is case-insensitive and ignores separators (snake/kebab/camel).
        Only variables present in the mapping are updated. Lines that are empty,
        comments, or contain curly braces are ignored.

        Args:
            file_path: Path to the configuration file to modify in-place.

        Returns:
            None. The file is modified in-place.

        """
        logger = self.logger
        updated_lines = 0
        flat_variables_dict = {convert_to_flatcase(k): v for k, v in self.env.items()}

        logger.info("Replacing variables in file: %s", file_path)
        with Path(file_path).open(encoding="utf-8") as file:
            lines = file.readlines()

        new_lines = []
        for line in lines:
            stripped_line = line.rstrip()

            if not is_line_valid(stripped_line):
                new_lines.append(line)
                continue

            match = re.match(REGEX, stripped_line)
            if match:
                pre_key, key, separator, old_value, post_value = match.groups()
                flat_key = convert_to_flatcase(key)

                if (
                    flat_key in flat_variables_dict
                    and flat_variables_dict[flat_key] != old_value
                ):
                    new_value = flat_variables_dict[flat_key]
                    updated_line = f"{pre_key}{key}{separator}{new_value}{post_value}\n"
                    logger.info(
                        "Updated variable '%s' from '%s' to '%s'",
                        key,
                        old_value,
                        new_value,
                    )
                    updated_lines += 1
                    new_lines.append(updated_line)
                else:
                    new_lines.append(line)
            else:
                new_lines.append(line)

        with Path(file_path).open("w", encoding="utf-8") as file:
            file.writelines(new_lines)

        logger.info("Total lines updated: %d", updated_lines)
        self.logger.info("-" * 40)

    def apply_configuration(self) -> tuple[str, str]:
        """Validate/create INI and SandboxVars, then apply replacements to both.

        Returns:
            A tuple (config_path, sandbox_path) of the updated files.

        """
        sandbox_path = self.validate_sandbox_file()
        config_path = self.validate_config_file()

        self.replace_file_variables(config_path)
        self.replace_file_variables(sandbox_path)

        self.logger.info("Configuration applied successfully.")
        self.logger.info("-" * 40)
        return config_path, sandbox_path
