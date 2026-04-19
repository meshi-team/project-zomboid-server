.PHONY: lint lint-python lint-shell lint-shell-fmt lint-yaml lint-docker fix-python fix-shell-fmt help

lint: lint-python lint-shell lint-shell-fmt lint-yaml lint-docker

lint-python:
	ruff check --config .config/ruff.toml --quiet .

lint-shell:
	shellcheck --rcfile=.config/.shellcheckrc $$(git ls-files '*.sh')

lint-shell-fmt:
	shfmt --diff $$(git ls-files '*.sh')

lint-yaml:
	yamllint --config-file .config/.yamllint.yml --strict .

lint-docker:
	hadolint --config .config/.hadolint.yml $$(git ls-files '**/Dockerfile' 'Dockerfile')

fix-python:
	ruff check --config .config/ruff.toml --fix --quiet .

fix-shell-fmt:
	shfmt -w $$(git ls-files '*.sh')

help:
	@echo "Targets:"
	@echo "  lint             Run all linters"
	@echo "  lint-python      ruff"
	@echo "  lint-shell       shellcheck"
	@echo "  lint-shell-fmt   shfmt --diff"
	@echo "  lint-yaml        yamllint"
	@echo "  lint-docker      hadolint"
	@echo "  fix-python       ruff --fix"
	@echo "  fix-shell-fmt    shfmt -w"
