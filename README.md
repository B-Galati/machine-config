# Usage

```bash
# Only required package, the rest is automatic
sudo apt update -y && sudo apt install -y make

# Set up everything
make install

# 1st install: Bitwarden is not reachable yet, the sudo password is prompted instead
make install NO_BW=1

# Install a given role
make install ARGS="-t docker"

# Force install of discord
make install ARGS="-t discord -e force_install=true}"

# Update everything on the machine
make update
```

# References

- [Disable error report dialog](https://www.kevin-custer.com/blog/how-to-turn-off-the-error-report-dialog-in-ubuntu-20-04/)
- [Configuration files in the environment.d/](https://www.freedesktop.org/software/systemd/man/latest/environment.d.html)
- [Ansible Vault with different backends](https://www.monotux.tech/posts/2025/03/ansible-vault/)
- [Storing Ansible Vault Password in Bitwarden](https://theorangeone.net/posts/ansible-vault-bitwarden/)

# Credits

- [Omakub](https://github.com/basecamp/omakub)
- [Jared Hocutt labtop config](https://github.com/jaredhocutt/laptop)
