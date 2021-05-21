.PHONY: default
default:
	@echo 'You must specify a target'

.PHONY: install
install: install.lock vault.yaml requirements
	@echo 'Install system config'
	@ansible-playbook machine.yaml --vault-id vault.txt --verbose
	@echo 'Install dotfiles'
	@~/dotfiles/bootstrap.sh --force
	@echo "Logout and login if it's the very first install"

.PHONY: role
role:
	@if [[ -z "$(ROLE)" ]]; then echo 'You must specify a value for ROLE variable' && exit 1; fi
	@echo 'Install role "$(ROLE)"'
	@ansible-playbook machine.yaml --vault-id vault.txt --verbose --tag $(ROLE)

.PHONY: update
update:
	@echo 'Update repo'
	git pull
	ansible-playbook machine.yaml --vault-id vault.txt --verbose --tag user # This line allow to unlock sudo as well for the commands below
	@echo 'Update system'
	if which dnf > /dev/null 2>&1; then sudo dnf upgrade --refresh -y; fi
	if which apt > /dev/null 2>&1; then sudo apt update -y && sudo apt upgrade -y --autoremove --purge; fi
	@echo 'Clean up'
	if which dnf > /dev/null 2>&1; then sudo dnf autoremove -y; fi
	if which apt > /dev/null 2>&1; then sudo apt-get autoclean -y; fi
	@echo 'Update Symfony CLI'
	symfony self:update -y
	@echo 'Update composer'
	composer selfupdate -n
	@echo 'Update rust and local binaries'
	rustup update
	@echo 'Update python deps'
	pip install --upgrade --user pip awscli s-tui psutil powerline-mem-segment youtube-dl
	@echo 'Update node deps'
	npm -g update
	@echo 'Update dotfiles'
	cd ~/dotfiles && git pull && git submodule update --remote --rebase
	~/dotfiles/bootstrap.sh --force

.PHONY: requirements
requirements: requirements.lock
requirements.lock: requirements.yaml
	ansible-galaxy install --role-file requirements.yaml --roles-path ./roles --force
	@touch $@

vault.yaml: vault.txt
	@echo "[PAUSE] you will need to specify ansible variable ansible_become_pass in the vault"
	@echo "Press a key to continue..."
	@read var
	@ansible-vault create --vault-password-file vault.txt vault.yaml

vault.txt:
	@dd if=/dev/urandom bs=1 count=32 2>/dev/null | base64 -w 0 > vault.txt

install.lock:
	@echo "1st time run, let's install required tools"
	@echo "Check that python3 is installed and press any key..."
	@python --version
	@pip --version
	@read var
	@echo "Install Ansible..."
	@pip install --user ansible
	# Success! let's create the lock file not to run this step again
	@touch $@
