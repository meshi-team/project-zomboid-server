import re
from pathlib import Path

from utils import REGEX, convert_to_flatcase, is_line_valid, setup_logger


def validate_config_file(server_name: str, env: dict) -> str:
    """Ensure the server configuration file exists and return its path.

    If a configuration file for the given server_name does not exist under
    CACHE_DIR/Server (default "/root/Zomboid/Server"), this function copies
    DEFAULTS_DIR/default.ini (default "/defaults/default.ini") to that location,
    creating any necessary parent directories. The env mapping may supply the
    DEFAULTS_DIR and CACHE_DIR keys to override the defaults.

    Args:
        server_name (str): The name of the server (used to name the .ini file).
        env (dict): Environment-like dictionary that may contain "DEFAULTS_DIR"
                    and "CACHE_DIR" to override default directories.

    Returns:
        str: The full path to the server's configuration file.

    """
    defaults_dir = env.get("DEFAULTS_DIR", "/defaults")
    default_file = f"{defaults_dir}/default.ini"

    cache_dir = env.get("CACHE_DIR", "/root/Zomboid")
    config_file = f"{cache_dir}/Server/{server_name}.ini"

    if not Path(config_file).exists():
        default_path = Path(default_file)
        Path(config_file).parent.mkdir(parents=True, exist_ok=True)
        Path(config_file).write_text(default_path.read_text())

    return config_file


def validate_sandbox_file(server_name: str, env: dict) -> str:
    """Validate or create a server SandboxVars file for a given server.

    This function determines which SandboxVars source to use (a selected preset,
    the existing server sandbox file, or the default sandbox file), optionally
    forces a preset, converts the file content by replacing a leading "return"
    with "SandboxVars =", ensures the target directory exists, writes the resulting
    content to the server sandbox path, and returns that path.

    Args:
        server_name (str): Name of the server (used to build the target filename).
        env (dict): Environment/configuration mapping. Expected keys:
            - DEFAULTS_DIR: directory containing default_SandboxVars.lua
            - CACHE_DIR: base cache directory (default "/root/Zomboid")
            - PRESETS_DIR: directory containing preset .lua files
            - SERVER_PRESET: name of selected preset (without .lua)
            - FORCE_PRESET: "1" to force using the selected preset
                even if sandbox exists

    Returns:
        str: Full path to the sandbox file that was written.

    Raises:
        OSError or subclasses (e.g., FileNotFoundError) if file operations fail.

    """
    logger = setup_logger()
    defaults_dir = env.get("DEFAULTS_DIR", "/defaults")
    default_file = f"{defaults_dir}/default_SandboxVars.lua"

    cache_dir = env.get("CACHE_DIR", "/root/Zomboid")
    sandbox_file = f"{cache_dir}/Server/{server_name}_SandboxVars.lua"

    presets_dir = env.get("PRESETS_DIR")
    selected_preset = env.get("SERVER_PRESET")
    force_preset = env.get("FORCE_PRESET", "0") == "1"
    preset_file = f"{presets_dir}/{selected_preset}.lua" if selected_preset else None

    if preset_file and not Path(preset_file).exists():
        preset_file = None
        logger.warning('Preset "%s" doesn\'t exist, skipping', selected_preset)

    if not Path(sandbox_file).exists():
        default_path = Path(preset_file) if preset_file else Path(default_file)

    else:
        default_path = Path(sandbox_file)
        if preset_file and force_preset:
            logger.info('Forcing preset "%s"', selected_preset)
            default_path = Path(preset_file)

    default_content = default_path.read_text().replace("return", "SandboxVars =")
    Path(sandbox_file).parent.mkdir(parents=True, exist_ok=True)
    Path(sandbox_file).write_text(default_content)

    return sandbox_file


def replace_file_variables(file_path: str, variables_mapping: dict) -> None:
    """Replace variables in a config file with new values.

    Reads the file at file_path, finds lines containing variables present in
    variables_mapping, and replaces their values. The updated content is written
    to the same file. Variable name matching is case-insensitive and ignores separators.

    Args:
        file_path (str): Path to the input configuration file.
        variables_mapping (dict): Mapping of variable names to new values.

    Returns:
        None

    """
    logger = setup_logger()
    flat_variables_dict = {
        convert_to_flatcase(k): v for k, v in variables_mapping.items()
    }

    with Path(file_path).open() as file:
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
                new_lines.append(updated_line)
            else:
                new_lines.append(line)
        else:
            new_lines.append(line)

    with Path(file_path).open("w") as file:
        file.writelines(new_lines)
