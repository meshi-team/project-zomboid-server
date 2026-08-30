from __future__ import annotations

import re
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from pathlib import Path

# The .acf files are Valve KeyValues: quoted strings plus braces for nesting.
TOKEN_RE = re.compile(r'"((?:[^"\\]|\\.)*)"|([{}])')

INSTALLED_SECTION = "WorkshopItemsInstalled"
DETAILS_SECTION = "WorkshopItemDetails"


def parse_vdf(text: str) -> dict:
    """Parse a Valve KeyValues (VDF) document into nested dictionaries.

    Args:
        text: Raw contents of the .acf file.

    Returns:
        The parsed document. Scalar values stay as strings.

    """
    tokens = [m.group(1) if m.group(1) is not None else m.group(2) for m in TOKEN_RE.finditer(text)]
    pos = 0

    def parse_block() -> dict:
        nonlocal pos
        block: dict = {}
        while pos < len(tokens):
            key = tokens[pos]
            if key == "}":
                pos += 1
                return block
            pos += 1
            if pos >= len(tokens):
                break
            if tokens[pos] == "{":
                pos += 1
                block[key] = parse_block()
            else:
                block[key] = tokens[pos]
                pos += 1
        return block

    return parse_block()


def read_installed_times(manifest: Path) -> dict[str, int]:
    """Read the install timestamp Steam recorded for each Workshop item.

    Args:
        manifest: Path to `appworkshop_<appid>.acf`.

    Returns:
        Mapping of Workshop item ID to its `timeupdated`. Empty when the
        manifest is missing or unreadable, so callers fall back to disk.

    """
    try:
        text = manifest.read_text(encoding="utf-8", errors="replace")
    except OSError:
        return {}

    installed = parse_vdf(text).get("AppWorkshop", {}).get(INSTALLED_SECTION, {})

    times: dict[str, int] = {}
    for item_id, details in installed.items():
        if not isinstance(details, dict):
            continue
        try:
            times[item_id] = int(details.get("timeupdated", 0))
        except (TypeError, ValueError):
            times[item_id] = 0
    return times


def drop_item_entry(text: str, section: str, item_id: str) -> str:
    """Remove one item's block from a section of a KeyValues document.

    Rewriting the whole manifest would make Steam forget every item that is not
    re-downloaded, so stale entries are cut out surgically instead.

    Args:
        text: Raw manifest contents.
        section: Section holding the per-item blocks.
        item_id: Workshop item ID whose block should be removed.

    Returns:
        The manifest with that block removed, unchanged if it was not found.

    """
    section_at = text.find(f'"{section}"')
    if section_at < 0:
        return text

    item_at = text.find(f'"{item_id}"', section_at)
    open_at = text.find("{", item_at) if item_at >= 0 else -1
    if open_at < 0:
        return text

    depth = 0
    for pos in range(open_at, len(text)):
        if text[pos] == "{":
            depth += 1
        elif text[pos] == "}":
            depth -= 1
            if depth == 0:
                start = text.rfind("\n", 0, item_at) + 1
                end = text.find("\n", pos)
                return text[:start] + (text[end + 1 :] if end >= 0 else "")

    return text


def prune_items(manifest: Path, item_ids: set[str]) -> bool:
    """Drop the given Workshop items from the Steam manifest.

    Steam skips downloading an item its manifest already claims as installed,
    so an entry has to go before that item can be fetched again.

    Args:
        manifest: Path to `appworkshop_<appid>.acf`.
        item_ids: Workshop item IDs to forget.

    Returns:
        True when the manifest no longer claims any of the items, including the
        case where there was no manifest to begin with. False when the rewrite
        failed, leaving the file untouched.

    """
    if not item_ids or not manifest.is_file():
        return True

    try:
        text = manifest.read_text(encoding="utf-8", errors="replace")
    except OSError:
        return False

    for item_id in item_ids:
        for section in (INSTALLED_SECTION, DETAILS_SECTION):
            text = drop_item_entry(text, section, item_id)

    # A botched cut would hand Steam a corrupt manifest; check before writing.
    remaining = parse_vdf(text).get("AppWorkshop", {}).get(INSTALLED_SECTION, {})
    if any(item_id in remaining for item_id in item_ids):
        return False

    try:
        manifest.write_text(text, encoding="utf-8")
    except OSError:
        return False

    return True
