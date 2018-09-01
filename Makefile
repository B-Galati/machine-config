.PHONY: default
default:
	@echo 'You must specify a target'

.PHONY: install
install: install.lock vault.yaml
	ansible-galaxy install --role-file requirements.yaml --roles-path ./roles
	ansible-playbook machine.yaml --vault-id vault.txt --verbose
	~/dotfiles/bootstrap.sh

vault.yaml: vault.txt
	@echo "[PAUSE] you will need to specify ansible variable ansible_become_pass in the vault"
	@echo "Press to continue..."
	@read var
	ansible-vault create --vault-password-file vault.txt vault.yaml

vault.txt:
	@dd if=/dev/urandom bs=1 count=32 2>/dev/null | base64 -w 0 > vault.txt

install.lock:
	@echo "1st time run, let's install required tools"
	sudo apt update -y
	sudo apt install -y software-properties-common
	sudo apt-add-repository -y ppa:ansible/ansible
	sudo apt install ansible git ssh -y
	# Success! let's create the lock file not to run this step again
	@touch install.lock
