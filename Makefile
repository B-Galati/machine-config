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

define git_pull
	@$(call log,Fetching $(1))
	@git -C $(1) fetch origin master
	@$(call log,Changelog for $(1))
	@git -C $(1) log --oneline --no-merges --format=format:'- %s' HEAD..origin/master
	@$(call log,Updating $(1))
	@git -C $(1) pull origin master
endef

# Make sure the path is up-to-date for the 1st time setup, otherwise ansible may not be found
export PATH:=$(HOME)/.local/bin:$(PATH)

.PHONY: default
default:
	@$(call log_error, You must specify a target)

.PHONY: unlock-bitwarden
unlock-bitwarden:
	@bw unlock --check > /dev/null 2>&1 || { echo 'Bitwarden is locked. Run: export BW_SESSION=$$(bw unlock --raw)'; exit 1; }
	@sudo -nv 2>/dev/null || { pw=$$(ansible-vault view vault.yaml | yq '.ansible_become_password') && echo "$$pw" | sudo -Sv; }

.PHONY: install
install: ~/.ssh/id_rsa install.lock requirements vault.yaml unlock-bitwarden
	ansible-playbook machine.yaml --verbose $(ARGS)
	@$(call log_success,Done! You may need to restart the computer to make sure everything works as expected)

~/.ssh/id_rsa:
	@$(call log_error, SSH key must be installed before installation)
	@exit 1

.PHONY: update
update: unlock-bitwarden
	@$(call log,Update repo)
	git pull
# Restart Make to ensure we use an up-to-date Makefile
	$(MAKE) do-update

.PHONY: do-update
do-update:
	@$(call log,Update some repositories)
	$(call git_pull,~/.oh-my-zsh)
	$(call git_pull,~/.oh-my-zsh/custom/plugins/k3d)
	$(call git_pull,~/docs)
	$(call git_pull,/opt/kubectx)
	@$(call log,Update dotfiles)
	$(call git_pull,~/dotfiles)
	~/dotfiles/bootstrap.sh --force
	@$(call log,Update system)
	if which dnf > /dev/null 2>&1; then sudo dnf upgrade --refresh -y; fi
	if which apt > /dev/null 2>&1; then sudo apt update -y && sudo apt upgrade -y --autoremove --purge; fi
	@$(call log,Clean up)
	if which dnf > /dev/null 2>&1; then sudo dnf autoremove -y; fi
	if which apt > /dev/null 2>&1; then sudo apt-get autoclean -y; fi
	@$(call log,Update flatpak packages)
	if which flatpak > /dev/null 2>&1; then flatpak update -y; fi
	@$(call log,Update snap packages)
	if which snap > /dev/null 2>&1; then sudo snap refresh; fi
	@$(call log,Update gnome extensions)
	gext update -y --user
	$(MAKE) install ARGS="-t gnome-settings"
	@$(call log,Update composer)
	composer selfupdate -n
	@$(call log,Update rust and local binaries (toolchains))
	rustup update
	cargo install bandwhich grex alacritty sd starship tailspin difftastic
	@$(call log,Update python deps)
	~/.local/pipx-venv/bin/pip install --upgrade pipx
	pipx upgrade-all --include-injected
	@$(call log,Update NVM)
	(cd ~/.nvm && git fetch --tags origin && git checkout $$(git describe --abbrev=0 --tags --match "v[0-9]*" $$(git rev-list --tags --max-count=1)))
	\. ~/.nvm/nvm.sh

.PHONY: requirements
requirements: requirements.lock
requirements.lock: requirements.yaml
	ansible-galaxy install --role-file requirements.yaml --roles-path ./roles --force
	@touch $@

vault.yaml:
	@$(call log,[PAUSE] you will need to specify ansible variable ansible_become_pass in the vault)
	@$(call log,Press a key to continue...)
	@read var
	@ansible-vault create vault.yaml

install.lock:
	@$(call log,1st time run; installing required tools)
	@if which apt > /dev/null 2>&1; then \
        sudo add-apt-repository ppa:git-core/ppa -yn && \
        sudo apt update -y && \
        sudo apt install -y git python-is-python3 python3-pip \
    ; fi
	@if which dnf > /dev/null 2>&1; then \
         sudo dnf install -y git && \
         sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$$(rpm -E %fedora).noarch.rpm && \
         sudo dnf group upgrade --with-optional Multimedia \
    ; fi
	@$(call log,Install Bitwarden CLI)
	@BW_VERSION=$$(curl -s https://api.github.com/repos/bitwarden/clients/releases?per_page=30 | python3 -c "import json,sys; print(next(t.replace('cli-v','') for t in (r['tag_name'] for r in json.load(sys.stdin)) if t.startswith('cli-v')))") && \
		curl -sL "https://github.com/bitwarden/clients/releases/download/cli-v$${BW_VERSION}/bw-linux-$${BW_VERSION}.zip" -o /tmp/bw.zip && \
		sudo unzip -o /tmp/bw.zip -d /usr/local/bin && \
		sudo chmod 755 /usr/local/bin/bw && \
		rm /tmp/bw.zip
	@bw --version
	@$(call log,[PAUSE] Configure your Bitwarden server if needed (e.g. bw config server https://vault.bitwarden.eu) then press a key to continue...)
	@read var
	@$(call log,Please verify that python3 is installed)
	@python --version
	@pip --version
	@$(call log,Press any key to continue...)
	@read var
	@$(call log,install pipx)
	@python3 -m venv ~/.local/pipx-venv
	@~/.local/pipx-venv/bin/pip install --upgrade pipx
	@mkdir -p ~/.local/bin
	@ln -sf ~/.local/pipx-venv/bin/pipx ~/.local/bin/pipx
	@$(call log,Install Ansible)
	@pipx install --include-deps ansible
	@pipx inject --include-apps ansible jmespath
# Success! let's create the lock file not to run this step again
	@touch $@
