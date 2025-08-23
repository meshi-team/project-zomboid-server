import logging
import os
import re
import sys
from pathlib import Path

REGEX = re.compile(
    r"^(.*?)(\b\w+\b)(\s*=\s*)(\"(?:[^\"\\\\]|\\\\.)*\"|'(?:[^'\\\\]|\\\\.)*'|.*?)(?=\s*,?\s*(?:#.*)?$)(\s*,?\s*(?:#.*)?)$",
)


def setup_logger() -> logging.Logger:
    """Set up and return a logger with INFO level and stream handler.

    Returns:
        logging.Logger: Configured logger instance.

    """
    logger = logging.getLogger(__name__)
    logger.setLevel(logging.INFO)
    if not logger.hasHandlers():
        handler = logging.StreamHandler(sys.stdout)
        formatter = logging.Formatter("%(levelname)s: %(message)s")
        handler.setFormatter(formatter)
        logger.addHandler(handler)
    return logger


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


def load_custom_variables() -> dict:
    """Load the custom environment variables.

    Returns:
        dict: A dictionary containing the custom environment variables as
            key-value pairs (only variables present in the environment).

    """
    return dict(os.environ)


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


def rewrite_file_variables(
    file_path: str,
    variables_dict: dict,
    new_file_path: str,
) -> None:
    """Replace variables in a config file with new values and write to a new file.

    Reads the file at file_path, finds lines containing variables present in vars_dict,
    and replaces their values with those from vars_dict. The updated content is written
    to new_file_path. Variable name matching is case-insensitive and ignores separators.

    Args:
        file_path (str): Path to the input configuration file.
        variables_dict (dict): Mapping of variable names to new values.
        new_file_path (str): Path to write the updated configuration file.

    Returns:
        None

    """
    logger = setup_logger()
    flat_variables_dict = {convert_to_flatcase(k): v for k, v in variables_dict.items()}

    with Path(file_path).open() as file:
        lines = file.readlines()

    new_lines = []
    for line in lines:
        stripped_line = line.rstrip()

        if "return" in stripped_line:
            line = line.replace("return", "SandboxVars =")

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

    Path(new_file_path).parent.mkdir(parents=True, exist_ok=True)
    with Path(new_file_path).open("w") as file:
        file.writelines(new_lines)
