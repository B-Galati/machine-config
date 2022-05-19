MAKEFLAGS+=--no-builtin-rules # Disable built-in rules see https://www.gnu.org/software/make/manual/make.html#Canceling-Rules
SHELL:=/bin/bash

COLOR_RESET   = \033[0m
COLOR_SUCCESS = \033[32m
COLOR_ERROR   = \033[31m
COLOR_COMMENT = \033[33m

define log
	echo -e "[$(COLOR_COMMENT)$$(date +"%T")$(COLOR_RESET)][$(COLOR_COMMENT)$(@)$(COLOR_RESET)] $(COLOR_COMMENT)$(1)$(COLOR_RESET)"
endef

define log_success
	echo -e "[$(COLOR_SUCCESS)$$(date +"%T")$(COLOR_RESET)][$(COLOR_SUCCESS)$(@)$(COLOR_RESET)] $(COLOR_SUCCESS)$(1)$(COLOR_RESET)"
endef

define log_error
	echo -e "[$(COLOR_ERROR)$$(date +"%T")$(COLOR_RESET)][$(COLOR_ERROR)$(@)$(COLOR_RESET)] $(COLOR_ERROR)$(1)$(COLOR_RESET)"
endef

.PHONY: default
default:
	@$(call log_error, You must specify a target)

.PHONY: install
install: install.lock vault.yaml requirements
	@$(call log,Install system config)
	ansible-playbook machine.yaml --vault-id vault.txt --verbose
	@$(call log,Install dotfiles)
	~/dotfiles/bootstrap.sh --force
	@$(call log,Restart the computer to make sure everything works)

.PHONY: role
role:
	@if [[ -z "$(ROLE)" ]]; then $(call log_error, You must specify a value for ROLE variable) && exit 1; fi
	@echo 'Install role "$(ROLE)"'
	ansible-playbook machine.yaml --vault-id vault.txt --verbose --tag $(ROLE)

.PHONY: update
update:
	@$(call log,Update repo)
	git pull
	ansible-playbook machine.yaml --vault-id vault.txt --verbose --tag user # This line allow to unlock sudo as well for the commands below
	@$(call log,Update system)
	if which dnf > /dev/null 2>&1; then sudo dnf upgrade --refresh -y; fi
	if which apt > /dev/null 2>&1; then sudo apt update -y && sudo apt upgrade -y --autoremove --purge; fi
	@$(call log,Clean up)
	if which dnf > /dev/null 2>&1; then sudo dnf autoremove -y; fi
	if which apt > /dev/null 2>&1; then sudo apt-get autoclean -y; fi
	@$(call log,Update flatpak packages)
	if which flatpak > /dev/null 2>&1; then flatpak update -y; fi
	@$(call log,Update composer)
	composer selfupdate -n
	@$(call log,Update rust and local binaries (toolchains))
	rustup update
	@$(call log,Update python deps)
	pip install --upgrade --user awscli s-tui psutil powerline-mem-segment youtube-dl yubikey-manager
	@$(call log,Update node deps)
	npm -g update
	@$(call log,Update OMZ)
	zsh -c 'source ~/.zshrc && omz update'
	@$(call log,Update dotfiles)
	cd ~/dotfiles && git pull && git submodule update --remote --rebase
	~/dotfiles/bootstrap.sh --force

.PHONY: requirements
requirements: requirements.lock
requirements.lock: requirements.yaml
	ansible-galaxy install --role-file requirements.yaml --roles-path ./roles --force
	ansible-galaxy collection install community.general
	@touch $@

vault.yaml: vault.txt
	@$(call log,[PAUSE] you will need to specify ansible variable ansible_become_pass in the vault)
	@$(call log,Press a key to continue...)
	@read var
	@ansible-vault create --vault-password-file vault.txt vault.yaml

vault.txt:
	@dd if=/dev/urandom bs=1 count=32 2>/dev/null | base64 -w 0 > vault.txt
	@chmod 600 vault.txt

install.lock:
	@$(call log,1st time run; installing required tools)
	@if which apt > /dev/null 2>&1; then \
         sudo apt update -y && \
         sudo apt install git python-is-python3 python3-pip \
    ; fi
	@if which dnf > /dev/null 2>&1; then \
         sudo dnf install -y git && \
         sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
         sudo dnf group upgrade --with-optional Multimedia \
    ; fi
	@$(call log,Please verify that python3 is installed)
	@python --version
	@pip --version
	@$(call log,Press any key to continue...)
	@read var
	@$(call log,Install Ansible)
	@pip install --user ansible
# Success! let's create the lock file not to run this step again
	@touch $@
