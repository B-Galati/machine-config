.PHONY: default
default:
	@echo 'You must specify a target'

.PHONY: install
install: install.lock
	ansible-playbook machine.yaml -i '127.0.0.1' --verbose

install.lock:
	@echo "1st time run, let's install required tools"
	sudo apt update -y && sudo apt install ansible -y
	# Success! let's create the lock file not to run this step again
	touch install.lock
