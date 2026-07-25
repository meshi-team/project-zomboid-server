from __future__ import annotations

import json
import re
import urllib.parse
import urllib.request
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    import logging

STEAM_API_BASE_URL = "https://api.steampowered.com/ISteamRemoteStorage"
REQUEST_TIMEOUT_SECONDS = 30
STEAM_RESULT_OK = 1

# Project Zomboid mod authors advertise the mod ID in the Workshop item
# description following the "Mod ID: <id>" convention.
MOD_ID_RE = re.compile(r"^\s*Mod\s?ID(?P<plural>s?)\s*:\s*(?P<mod_id>[\w.&-]+)(?P<extra>.*?)\s*$", re.MULTILINE)

# Workshop descriptions use BBCode; tags such as [b] or [h1] would hide the
# "Mod ID:" convention from the regex above.
BBCODE_TAG_RE = re.compile(r"\[/?[^\[\]]*\]")


class SteamCollectionResolver:
    """Resolve Steam Workshop collections into Workshop item IDs and mod IDs.

    Uses two public Steam Web API endpoints (no API key required):
        - GetCollectionDetails: expands collection IDs into the Workshop
          items they contain.
        - GetPublishedFileDetails: fetches the details of each Workshop item,
          from which the mod IDs are derived by parsing the "Mod ID: <id>"
          convention that Project Zomboid authors follow in the description.

    Network or parsing failures are logged and produce empty results, so the
    server startup continues with the manually configured selection.
    """

    def __init__(self, logger: logging.Logger) -> None:
        """Initialize the resolver.

        Args:
            logger: Logger used to report resolution progress and failures.

        """
        self.logger = logger

    def get_collection_items(self, collection_ids: set[str]) -> set[str]:
        """Expand Workshop collections into the Workshop item IDs they contain.

        Args:
            collection_ids: Set of Workshop collection IDs (numeric strings).

        Returns:
            A set of Workshop item IDs (strings). Empty if nothing could be resolved.

        """
        valid_ids = self._keep_numeric_ids(collection_ids)
        if not valid_ids:
            return set()

        response = self._query_api("GetCollectionDetails", "collectioncount", valid_ids)
        items: set[str] = set()

        for collection in (response or {}).get("collectiondetails", []):
            collection_id = collection.get("publishedfileid", "?")
            if collection.get("result") != STEAM_RESULT_OK:
                self.logger.error("Could not resolve collection %s, check that it exists and is public", collection_id)
                continue

            children = {
                child["publishedfileid"] for child in collection.get("children", []) if "publishedfileid" in child
            }
            self.logger.info("Collection %s contains %d workshop item(s)", collection_id, len(children))
            items |= children

        return items

    def get_item_mod_ids(self, workshop_ids: set[str]) -> set[str]:
        """Derive the mod IDs of Workshop items from their descriptions.

        Items that are banned or whose description does not declare exactly
        one mod ID are skipped with a log entry, so they can be added manually
        through the `MODS` environment variable instead.

        Args:
            workshop_ids: Set of Workshop item IDs (numeric strings).

        Returns:
            A set of mod IDs (strings). Empty if nothing could be resolved.

        """
        valid_ids = self._keep_numeric_ids(workshop_ids)
        if not valid_ids:
            return set()

        response = self._query_api("GetPublishedFileDetails", "itemcount", valid_ids)
        mod_ids: set[str] = set()

        for details in (response or {}).get("publishedfiledetails", []):
            mod_id = self._extract_mod_id(details)
            if mod_id:
                mod_ids.add(mod_id)

        return mod_ids

    def _keep_numeric_ids(self, ids: set[str]) -> set[str]:
        """Filter out IDs that are not numeric, logging the discarded ones."""
        for invalid in sorted(item for item in ids if not item.isdigit()):
            self.logger.error("Ignoring invalid Workshop ID: %r", invalid)
        return {item for item in ids if item.isdigit()}

    def _query_api(self, method: str, count_key: str, file_ids: set[str]) -> dict | None:
        """POST a set of published file IDs to a Steam Web API method.

        Args:
            method: ISteamRemoteStorage method name to call.
            count_key: Name of the form field holding the amount of IDs.
            file_ids: Published file IDs to send.

        Returns:
            The `response` object of the JSON payload, or None on failure.

        """
        form = {f"publishedfileids[{i}]": file_id for i, file_id in enumerate(sorted(file_ids))}
        form[count_key] = str(len(file_ids))
        request = urllib.request.Request(  # noqa: S310 - fixed https:// base URL
            f"{STEAM_API_BASE_URL}/{method}/v1/",
            data=urllib.parse.urlencode(form).encode(),
        )

        try:
            with urllib.request.urlopen(request, timeout=REQUEST_TIMEOUT_SECONDS) as raw:  # noqa: S310
                payload = json.load(raw)
        except (OSError, ValueError) as exc:
            self.logger.error("Steam API request %s failed: %s", method, exc)
            return None

        response = payload.get("response") if isinstance(payload, dict) else None
        if not isinstance(response, dict):
            self.logger.error("Malformed Steam API response from %s: %r", method, payload)
            return None

        return response

    def _extract_mod_id(self, details: dict) -> str | None:
        """Extract the mod ID advertised in a Workshop item description.

        Args:
            details: One `publishedfiledetails` entry from the Steam API.

        Returns:
            The mod ID, or None when the item is banned, unavailable, or does
            not declare exactly one unambiguous mod ID.

        """
        item_id = details.get("publishedfileid", "?")
        title = details.get("title", "unknown")

        if details.get("result") != STEAM_RESULT_OK:
            self.logger.error("Could not fetch details of workshop item %s", item_id)
            return None

        if details.get("banned"):
            reason = details.get("ban_reason") or "no reason given"
            self.logger.warning("Workshop item %s ('%s') is banned (%s), skipping", item_id, title, reason)
            return None

        description = BBCODE_TAG_RE.sub("", details.get("description", "")).replace("\r", "")
        matches = list(MOD_ID_RE.finditer(description))

        if not matches:
            self.logger.error(
                "No 'Mod ID:' line found for workshop item %s ('%s'), add its mod ID to the MODS variable manually",
                item_id,
                title,
            )
            return None

        has_ambiguous_lines = any(match["plural"] or match["extra"] for match in matches)
        distinct_ids = {match["mod_id"] for match in matches}

        if has_ambiguous_lines or len(distinct_ids) > 1:
            self.logger.error(
                "Workshop item %s ('%s') declares multiple or ambiguous mod IDs (%s), "
                "add the right ones to the MODS variable manually",
                item_id,
                title,
                ", ".join(sorted(distinct_ids)),
            )
            return None

        mod_id = next(iter(distinct_ids))
        self.logger.info("Workshop item %s ('%s') provides mod ID '%s'", item_id, title, mod_id)
        return mod_id
