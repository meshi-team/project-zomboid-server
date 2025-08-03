from pathlib import Path

from helpers import load_custom_variables, rewrite_file_variables, setup_logger


def main() -> None:
    """Set up and update the server configuration.

    This function loads environment variables, determines the appropriate configuration
    and sandbox files, applies any selected presets, and rewrites the configuration
    files with the updated variables.
    """
    logger = setup_logger()
    env_vars = load_custom_variables()

    cache_dir = env_vars["CACHE_DIR"]
    presets_dir = env_vars["PRESETS_DIR"]
    defaults_dir = env_vars["DEFAULTS_DIR"]
    selected_preset = env_vars["SERVER_PRESET"]
    server_name = env_vars["SERVER_NAME"]

    default_config_file = Path(defaults_dir) / "default.ini"
    default_sandbox_file = Path(defaults_dir) / "default_SandboxVars.lua"
    current_config_file = Path(cache_dir) / "Server" / f"{server_name}.ini"
    current_sandbox_file = Path(cache_dir) / "Server" / f"{server_name}_SandboxVars.lua"
    preset_file = (
        Path(presets_dir) / f"{selected_preset}.lua" if selected_preset else None
    )

    if current_config_file.exists():
        logger.info("Using current config file for %s.", server_name)
        default_config_file = current_config_file

    if current_sandbox_file.exists():
        logger.info("Using current sandbox file for %s.", server_name)
        default_sandbox_file = current_sandbox_file

    if preset_file and preset_file.exists():
        logger.info("Sandbox config overridden by preset: %s", selected_preset)
        default_sandbox_file = preset_file

    elif preset_file and not preset_file.exists():
        logger.error(
            'Preset file "%s" does not exist, make sure to select a valid preset name',
            selected_preset,
        )

    rewrite_file_variables(
        file_path=str(default_config_file),
        variables_dict=env_vars,
        new_file_path=str(current_config_file),
    )

    rewrite_file_variables(
        file_path=str(default_sandbox_file),
        variables_dict=env_vars,
        new_file_path=str(current_sandbox_file),
    )


if __name__ == "__main__":
    main()
