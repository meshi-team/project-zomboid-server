# Project Zomboid Server

This repository provides a Docker-based setup for running a Project Zomboid dedicated server. It is designed for easy deployment, development, and contribution.

## Development Environment Setup

### Using VS Code DevContainer (Recommended)

1. **Install [VS Code](https://code.visualstudio.com/) and [Docker](https://www.docker.com/)**
2. **Install the VS Code "Remote - Containers" extension**
3. **Clone this repository**
4. **Open the repository in VS Code**
5. When prompted, click **"Reopen in Container"** or run the `Remote-Containers: Reopen in Container` command

The DevContainer includes all necessary development tools:

- Various linters and formatters (yamllint, shellcheck, hadolint, etc.)
- Git configuration
- Shell utilities

## Contributing

1. **Fork the repository**
2. **Create a feature branch with a descriptive name**
3. **Make your changes following the code style guidelines**
4. **Run linting and formatting checks before committing**
5. **Submit a pull request with a conventional commit title:**
   - Format: `<type>(<scope>): <subject>`
   - Valid types: `feat`, `fix`, `perf`, `refactor`, `revert`, `chore`, `ci`, `docs`
6. **Ensure all CI checks pass**

## Workflow Tools

### Linting

```sh
npm run lint            # Run ESLint
npm run lint-fix        # Fix auto-fixable ESLint issues
```

### Formatting

```sh
npm run format          # Format code with Prettier
```
