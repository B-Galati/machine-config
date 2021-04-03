.PHONY: default
default:
	@echo 'You must specify a target'

.PHONY: install
install: install.lock vault.yaml requirements
	if which dnf; then sudo dnf upgrade --refresh; fi
	if which apt; then sudo apt update && sudo apt upgrade --autoremove --purge; fi
	ansible-playbook machine.yaml --vault-id vault.txt --verbose
	if which dnf; then sudo dnf dnf autoremove; fi
	if which apt; then sudo apt-get autoclean; fi
	~/dotfiles/bootstrap.sh --force

.PHONY: install-force
install-force:
	rm -rf requirements.lock
	$(MAKE) install

.PHONY: requirements
requirements: requirements.lock
requirements.lock: requirements.yaml
	ansible-galaxy install --role-file requirements.yaml --roles-path ./roles --force
	@touch $@

vault.yaml: vault.txt
	@echo "[PAUSE] you will need to specify ansible variable ansible_become_pass in the vault"
	@echo "Press a key to continue..."
	@read var
	ansible-vault create --vault-password-file vault.txt vault.yaml

vault.txt:
	@dd if=/dev/urandom bs=1 count=32 2>/dev/null | base64 -w 0 > vault.txt

install.lock:
	@echo "1st time run, let's install required tools"
	@echo "Check that python3 is installed and press any key..."
	@python --version
	@pip --version
	@read var
	@echo "Install Ansible..."
	pip install --user ansible
	# Success! let's create the lock file not to run this step again
	@touch $@
