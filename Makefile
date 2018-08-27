.PHONY: default
default:
	@echo 'You must specify a target'

.PHONY: install
install: install.lock
	ansible-playbook machine.yaml -K --verbose

install.lock:
	@echo "1st time run, let's install required tools"
	sudo apt update -y
	sudo apt install -y software-properties-common
	sudo apt-add-repository -y ppa:ansible/ansible
	sudo apt install ansible git ssh -y
	# Success! let's create the lock file not to run this step again
	touch install.lock
