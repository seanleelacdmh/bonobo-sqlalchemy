# Generated by Medikit 0.5.19 on 2018-04-01.
# All changes will be overriden.
# Edit Projectfile and run “make update” (or “medikit update”) to regenerate.

PACKAGE ?= bonobo_sqlalchemy
PYTHON ?= $(shell which python || echo python)
PYTHON_BASENAME ?= $(shell basename $(PYTHON))
PYTHON_DIRNAME ?= $(shell dirname $(PYTHON))
PYTHON_REQUIREMENTS_FILE ?= requirements.txt
PYTHON_REQUIREMENTS_DEV_FILE ?= requirements-dev.txt
QUICK ?= 
PIP ?= $(PYTHON) -m pip
PIP_INSTALL_OPTIONS ?= 
VERSION ?= $(shell git describe 2>/dev/null || git rev-parse --short HEAD)
PYTEST ?= $(PYTHON_DIRNAME)/pytest
PYTEST_OPTIONS ?= --capture=no --cov=$(PACKAGE) --cov-report html
YAPF ?= $(PYTHON) -m yapf
YAPF_OPTIONS ?= -rip
MEDIKIT ?= $(PYTHON) -m medikit
MEDIKIT_UPDATE_OPTIONS ?= 
MEDIKIT_VERSION ?= 0.5.19

.PHONY: clean format help install install-dev medikit quick test update update-requirements

install: .medikit/install   ## Installs the project.
.medikit/install: $(PYTHON_REQUIREMENTS_FILE) setup.py
	$(eval target := $(shell echo $@ | rev | cut -d/ -f1 | rev))
ifeq ($(filter quick,$(MAKECMDGOALS)),quick)
	@printf "Skipping \033[36m%s\033[0m because of \033[36mquick\033[0m target.\n" $(target)
else ifneq ($(QUICK),)
	@printf "Skipping \033[36m%s\033[0m because \033[36m$$QUICK\033[0m is not empty.\n" $(target)
else
	@printf "Applying \033[36m%s\033[0m target...\n" $(target)
	$(PIP) install $(PIP_INSTALL_OPTIONS) -U pip wheel
	$(PIP) install $(PIP_INSTALL_OPTIONS) -U -r $(PYTHON_REQUIREMENTS_FILE)
	@mkdir -p .medikit; touch $@
endif

clean:   ## Cleans up the working copy.
	rm -rf build dist *.egg-info .medikit/install .medikit/install-dev
	find . -name __pycache__ -type d | xargs rm -rf

install-dev: .medikit/install-dev   ## Installs the project (with dev dependencies).
.medikit/install-dev: $(PYTHON_REQUIREMENTS_DEV_FILE) $(PYTHON_REQUIREMENTS_FILE) setup.py
	$(eval target := $(shell echo $@ | rev | cut -d/ -f1 | rev))
ifeq ($(filter quick,$(MAKECMDGOALS)),quick)
	@printf "Skipping \033[36m%s\033[0m because of \033[36mquick\033[0m target.\n" $(target)
else ifneq ($(QUICK),)
	@printf "Skipping \033[36m%s\033[0m because \033[36m$$QUICK\033[0m is not empty.\n" $(target)
else
	@printf "Applying \033[36m%s\033[0m target...\n" $(target)
	$(PIP) install $(PIP_INSTALL_OPTIONS) -U pip wheel
	$(PIP) install $(PIP_INSTALL_OPTIONS) -U -r $(PYTHON_REQUIREMENTS_DEV_FILE)
	@mkdir -p .medikit; touch $@
endif

quick:   #
	@printf ""

test: install-dev  ## Runs the test suite.
	$(PYTEST) $(PYTEST_OPTIONS) tests

format: install-dev  ## Reformats the whole python codebase using yapf.
	$(YAPF) $(YAPF_OPTIONS) .
	$(YAPF) $(YAPF_OPTIONS) Projectfile

medikit:   # Checks installed medikit version and updates it if it is outdated.
	@$(PYTHON) -c 'import medikit, sys; from packaging.version import Version; sys.exit(0 if Version(medikit.__version__) >= Version("$(MEDIKIT_VERSION)") else 1)' || $(PYTHON) -m pip install -U "medikit>=$(MEDIKIT_VERSION)"

update: medikit  ## Update project artifacts using medikit.
	$(MEDIKIT) update $(MEDIKIT_UPDATE_OPTIONS)

update-requirements:   ## Update project artifacts using medikit, including requirements files.
	MEDIKIT_UPDATE_OPTIONS="--override-requirements" $(MAKE) update

help:   ## Shows available commands.
	@echo "Available commands:"
	@echo
	@grep -E '^[a-zA-Z_-]+:.*?##[\s]?.*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?##"}; {printf "    make \033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo
