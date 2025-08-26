import logging
import os
import re
import sys

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
