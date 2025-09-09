from server_manager import ProjectZomboidServerManager
from utils import load_custom_variables
from workshop_manager import ProjectZomboidWorkshopManager


def main() -> None:
    """Run the main routine."""
    # Load the needed environment variables
    variables = load_custom_variables()
    server_folder = variables.get("SERVER_DIR")
    steam_workshop_folder = variables.get("STEAM_WORKSHOP_DEFAULT_DIR")

    # Exectute the workshop manager first to ensure mods are in place
    wk_manager = ProjectZomboidWorkshopManager(server_folder, steam_workshop_folder)
    wk_manager.process_workshop_items()

    # Update the WORKSHOP_ITEMS variable to reflect only successfully processed items
    variables["WORKSHOP_ITEMS"] = ";".join(wk_manager.server_workshop_items)

    # Then proceed with server configuration
    server_manager = ProjectZomboidServerManager(variables)
    server_manager.apply_configuration()


if __name__ == "__main__":
    main()
