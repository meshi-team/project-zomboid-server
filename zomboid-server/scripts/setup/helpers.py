import logging
import os
import re
import sys
from pathlib import Path

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

if not logger.hasHandlers():
    handler = logging.StreamHandler(sys.stdout)
    formatter = logging.Formatter("%(levelname)s: %(message)s")
    handler.setFormatter(formatter)
    logger.addHandler(handler)

REGEX = re.compile(
    r"^(.*?)(\b\w+\b)(\s*=\s*)(\"(?:[^\"\\\\]|\\\\.)*\"|'(?:[^'\\\\]|\\\\.)*'|.*?)(?=\s*,?\s*(?:#.*)?$)(\s*,?\s*(?:#.*)?)$",
)


def is_line_valid(line: str) -> bool:
    """Check if a line is valid for processing.

    A valid line is not empty, does not start with a comment,
    and does not contain curly braces.

    Args:
        line (str): The line to check.

    Returns:
        bool: True if the line is valid, False otherwise.

    """
    stripped_line = line.strip()
    invalid_start = ("#", "--")
    invalid_chars = ("{", "}")

    return (
        bool(stripped_line)
        and not stripped_line.startswith(invalid_start)
        and not any(char in stripped_line for char in invalid_chars)
    )


def load_variables(file_path: str | None = None) -> dict:
    """Load environment variables from the system or a specified file.

    If no file path is provided, returns a dictionary of the current system
    environment variables. If a file path is given, reads the file and parses
    lines in the format 'KEY = VALUE', supporting quoted and unquoted values.
    Ignores comments and blank lines. Logs a warning for lines that do not
    match the expected format.

    Args:
        file_path (str | None): Path to an environment file to load variables from.
            If None, loads from the current system environment.

    Returns:
        dict: A dictionary containing environment variables as key-value pairs.

    Raises:
        FileNotFoundError: If the specified file does not exist.

    """
    if not file_path:
        return dict(os.environ)

    if not Path(file_path).exists():
        logger.error("Environment file '%s' does not exist.", file_path)
        msg = f"File '{file_path}' not found."
        raise FileNotFoundError(msg)

    with Path(file_path).open() as file:
        lines = file.readlines()
        env_vars = {}

        for line in lines:
            stripped_line = line.strip()
            if not is_line_valid(stripped_line):
                continue

            match = re.match(REGEX, stripped_line)
            if match:
                key, value = match.group(2), match.group(4)
                env_vars[key] = value
            else:
                logger.warning("Line '%s' does not match the format.", stripped_line)

    return env_vars


def convert_to_flatcase(text: str) -> str:
    """Convert a string to flatcase (all lowercase with no separators).

    Handles various naming conventions including snake_case, kebab-case,
    camelCase, PascalCase, and SCREAMING_SNAKE_CASE.

    Args:
        text (str): The input string in any common naming convention.

    Returns:
        str: The converted string in flatcase.

    """
    if not text:
        return text

    text = text.lower().strip()
    return re.sub(r"[-_\s]", "", text)


def extract_differential_values(config_map: dict, default_map: dict) -> dict:
    """Extract pairs from config_map whose values differ from those in default_map.

    Only include keys that exist in default_map. Key comparison is done in
    flatcase.

    Args:
        config_map (dict): The configuration map to filter.
        default_map (dict): The reference map of default values.

    Returns:
        dict: A new dict containing only those entries from config_map whose
        flattened keys are present in default_map and whose values differ.

    """
    flat_default = {convert_to_flatcase(k): v for k, v in default_map.items()}

    return {
        convert_to_flatcase(key): value
        for key, value in config_map.items()
        if (
            (fk := convert_to_flatcase(key)) in flat_default
            and flat_default[fk] != value
        )
    }


def replace_file_variables(
    file_path: str,
    variables_dict: dict,
    server_name: str,
) -> None:
    """Replace variables in a configuration file with new values.

    Reads the specified file, updates lines containing variables found in
    variables_dict, and writes the updated content to a new file whose name
    replaces 'template' with the given server_name.

    Args:
        file_path (str): Path to the configuration file to update.
        variables_dict (dict): Dictionary of variable names and their new values.
        server_name (str): Name to use in the output file name.

    Returns:
        None

    """
    flat_variables_dict = {convert_to_flatcase(k): v for k, v in variables_dict.items()}

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

            if flat_key in flat_variables_dict:
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

    new_file_path = file_path.replace("template", server_name)
    logger.info("Writing updated configuration to '%s'.", new_file_path)

    with Path(new_file_path).open("w") as file:
        file.writelines(new_lines)


def update_server_config(config_path: str, variables: dict) -> None:
    """Update the server configuration file with the provided variables.

    Args:
        config_path: Path to the server configuration file.
        variables: Variables to replace in the config file.

    """
    server_name = variables["SERVER_NAME"]
    default_vars = load_variables(config_path)
    custom_vars = extract_differential_values(variables, default_vars)
    logger.info(
        "Found %d custom variables to update in the config file.",
        len(custom_vars),
    )

    replace_file_variables(config_path, custom_vars, server_name)


def update_server_sandbox_config(
    sandbox_path: str,
    variables: dict,
    preset_path: str | None = None,
) -> None:
    """Update the server sandbox configuration file with the provided variables.

    Args:
        sandbox_path: Path to the sandbox configuration file.
        variables: Variables to replace in the sandbox file.
        preset_path: Optional path to a preset file.

    """
    server_name = variables["SERVER_NAME"]
    default_vars = load_variables(sandbox_path)
    custom_vars = extract_differential_values(variables, default_vars)
    logger.info(
        "Found %d custom variables to update in the sandbox file.",
        len(custom_vars),
    )

    if preset_path:
        logger.info("Applying preset '%s' to sandbox configuration.", preset_path)
        preset_vars = load_variables(preset_path)
        preset_diff = extract_differential_values(preset_vars, default_vars)
        logger.info("Found %d preset variables to apply.", len(preset_diff))

        custom_vars = {**preset_diff, **custom_vars}

    replace_file_variables(sandbox_path, custom_vars, server_name)
