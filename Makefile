MAKEFLAGS+=--warn-undefined-variables
MAKEFLAGS+=--no-builtin-rules # Disable built-in rules see https://www.gnu.org/software/make/manual/make.html#Canceling-Rules
.SHELLFLAGS:=-eu -o pipefail -c # Exit on error, prevent undefined var usage, throw error if one of pipeline operation fails
SHELL:=bash
ARGS?=

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

# Make sure the path is up-to-date for the 1st time setup, otherwise ansible may not be found
export PATH:=$(HOME)/.local/bin:$(PATH)

.PHONY: default
default:
	@$(call log_error, You must specify a target)

.PHONY: install
install: ~/.ssh/id_rsa install.lock requirements
	sudo -v
	ansible-playbook machine.yaml --verbose $(ARGS)
	@$(call log_success,Done! You may need to restart the computer to make sure everything works as expected)

~/.ssh/id_rsa:
	@$(call log_error, SSH key must be installed before installation)
	@exit 1

.PHONY: update
update:
	sudo -v
	@$(call log,Update repo)
	git pull
# Restart Make to ensure we use an up-to-date Makefile
	$(MAKE) do-update

.PHONY: do-update
do-update:
	@$(call log,Update some repositories)
	git -C ~/.oh-my-zsh pull
	git -C ~/.oh-my-zsh/custom/plugins/k3d pull
	git -C ~/z pull
	git -C ~/docs pull
	git -C /opt/kubectx pull origin master
	@$(call log,Update dotfiles)
	git -C ~/dotfiles pull
	~/dotfiles/bootstrap.sh --force
	@$(call log,Update system)
	if which dnf > /dev/null 2>&1; then sudo dnf upgrade --refresh -y; fi
	if which apt > /dev/null 2>&1; then sudo apt update -y && sudo apt upgrade -y --autoremove --purge; fi
	@$(call log,Clean up)
	if which dnf > /dev/null 2>&1; then sudo dnf autoremove -y; fi
	if which apt > /dev/null 2>&1; then sudo apt-get autoclean -y; fi
	@$(call log,Update flatpak packages)
	if which flatpak > /dev/null 2>&1; then flatpak update -y; fi
	@$(call log,Update gnome extensions)
	gext update -y
	@$(call log,Update composer)
	composer selfupdate -n
	@$(call log,Update rust and local binaries (toolchains))
	rustup update
	cargo install bandwhich grex alacritty sd starship tailspin difftastic
	@$(call log,Update python deps)
	pipx upgrade-all --include-injected
	@$(call log,Update NVM)
	(cd ~/.nvm && git fetch --tags origin && git checkout $$(git describe --abbrev=0 --tags --match "v[0-9]*" $$(git rev-list --tags --max-count=1)))
	\. ~/.nvm/nvm.sh

.PHONY: requirements
requirements: requirements.lock
requirements.lock: requirements.yaml
	ansible-galaxy install --role-file requirements.yaml --roles-path ./roles --force
	@touch $@

install.lock:
	@$(call log,1st time run; installing required tools)
	@if which apt > /dev/null 2>&1; then \
        sudo add-apt-repository ppa:git-core/ppa -yn && \
        sudo apt update -y && \
        sudo apt install -y git python-is-python3 python3-pip pipx \
    ; fi
	@if which dnf > /dev/null 2>&1; then \
         sudo dnf install -y git && \
         sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$$(rpm -E %fedora).noarch.rpm && \
         sudo dnf group upgrade --with-optional Multimedia \
    ; fi
	@$(call log,Please verify that python3 is installed)
	@python --version
	@pip --version
	@$(call log,Press any key to continue...)
	@read var
	@$(call log,Install Ansible)
	@pipx install --include-deps ansible
	@pipx inject --include-apps ansible jmespath
# Success! let's create the lock file not to run this step again
	@touch $@
