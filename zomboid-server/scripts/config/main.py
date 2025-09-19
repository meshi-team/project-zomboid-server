#!/bin/python3

import os

from server_manager import ProjectZomboidServerManager
from utils import load_custom_variables, setup_logger
from workshop_manager import ProjectZomboidWorkshopManager


def main() -> None:
    """Run the main routine."""
    # Load the needed environment variables
    logger = setup_logger()
    variables = load_custom_variables()
    server_folder = variables.get("SERVER_DIR")
    steam_workshop_folder = variables.get("STEAM_WORKSHOP_DEFAULT_DIR")

    # Exectute the workshop manager first to ensure mods are in place
    logger.info("-" * 40)
    logger.info("WORKSHOP MANAGEMENT")

    wk_manager = ProjectZomboidWorkshopManager(server_folder, steam_workshop_folder)
    wk_manager.process_workshop_items()

    # Update the WORKSHOP_ITEMS variable to reflect only successfully processed items
    variables["WORKSHOP_ITEMS"] = ";".join(wk_manager.server_workshop_items)
    variables["MAP"] = wk_manager.get_maps_string()

    # If the Map order is manually specified, override the automatic map definition
    if os.getenv("MAP"):
        variables["MAP"] = os.getenv("MAP")

    logger.info("-" * 40)
    logger.info("SERVER CONFIGURATION")

    # Then proceed with server configuration
    server_manager = ProjectZomboidServerManager(variables)
    server_manager.apply_configuration()


if __name__ == "__main__":
    main()
