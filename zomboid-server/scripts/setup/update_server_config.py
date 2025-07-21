import logging
import sys
from pathlib import Path

from helpers import load_variables, update_server_config, update_server_sandbox_config

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

if not logger.hasHandlers():
    handler = logging.StreamHandler(sys.stdout)
    formatter = logging.Formatter("%(levelname)s: %(message)s")
    handler.setFormatter(formatter)
    logger.addHandler(handler)

if __name__ == "__main__":
    env_vars = load_variables()

    cache_dir = env_vars["CACHE_DIR"]
    selected_preset = env_vars["SERVER_PRESET"]
    server_name = env_vars["SERVER_NAME"]
    presets_dir = env_vars["PRESETS_DIR"]

    default_config_file = f"{cache_dir}/Server/servertest.ini"
    default_sandbox_file = f"{cache_dir}/Server/servertest_SandboxVars.lua"

    preset_file = f"{presets_dir}/{selected_preset}.lua" if selected_preset else None

    if preset_file and not Path(preset_file).is_file():
        logger.error("Preset file '%s' does not exist.", preset_file)
        preset_file = None

    logger.info("Updating server configuration for '%s'.", server_name)
    update_server_config(default_config_file, env_vars)

    logger.info("-" * 60)

    logger.info("Updating server sandbox configuration for '%s'.", server_name)
    update_server_sandbox_config(default_sandbox_file, env_vars, preset_file)
