from server_config import (
    replace_file_variables,
    validate_config_file,
    validate_sandbox_file,
)
from utils import load_custom_variables, setup_logger


def main() -> None:
    """Run the main routine."""
    logger = setup_logger()
    variables = load_custom_variables()
    server_name = variables["SERVER_NAME"]

    logger.info("Validating configuration for server: %s", server_name)
    sandbox_path = validate_sandbox_file(server_name, variables)
    config_path = validate_config_file(server_name, variables)

    logger.info("Applying variable replacements in config files.")
    replace_file_variables(config_path, variables)
    replace_file_variables(sandbox_path, variables)

    logger.info("Configuration process completed.")


if __name__ == "__main__":
    main()
