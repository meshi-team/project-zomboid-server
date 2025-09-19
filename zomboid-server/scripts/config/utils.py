import logging
import os
import re
import shutil
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


# Pretty logging helpers
_RULE_WIDTH = 50


def log_rule(logger: logging.Logger, char: str = "-") -> None:
    """Print a horizontal rule using the provided character."""
    logger.info(char * _RULE_WIDTH)


def log_section(logger: logging.Logger, title: str) -> None:
    """Print a well-formatted section header."""
    logger.info("")
    logger.info("%s", "=" * _RULE_WIDTH)
    logger.info("%s", title.upper())
    logger.info("%s", "=" * _RULE_WIDTH)


def short_name(path_like: str | Path) -> str:
    """Return only the final component (name) of a path-like string."""
    try:
        return Path(str(path_like)).name
    except (TypeError, ValueError, OSError):
        return str(path_like)


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


def generate_symlink(source: Path, target: Path) -> bool:
    """Create or update a symbolic link from ``target`` pointing to ``source``.

    Args:
        source (Path): The source path (usually an existing directory).
        target (Path): The link path to create/update.

    Returns:
        bool: True if the link points to the desired source or was created successfully;
              False if an OS error occurred while creating/updating the link.

    """
    try:
        target.parent.mkdir(parents=True, exist_ok=True)

        if target.is_symlink():
            current = target.readlink()
            if str(current) != str(source):
                target.unlink()
                target.symlink_to(source)
        elif target.exists():
            if target.is_dir():
                shutil.rmtree(target)
            else:
                target.unlink()
            target.symlink_to(source)
        else:
            target.symlink_to(source)
    except OSError:
        return False

    return True
