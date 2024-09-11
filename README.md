# Usage

```bash
# Set up everything
make install

# Install a given role
make install ARGS="-t docker"

# Force install of discord
make install ARGS="-t discord -e '{"force_install": true}'"

# Update everything on the machine
make update
```

# Ideas of some things to do manually 

- Configure TLP to optimize battery lifetime

# References

- [Disable Ubuntu snaps](https://www.kevin-custer.com/blog/disabling-snaps-in-ubuntu-20-04/)
- [Disable boot screen](https://www.kevin-custer.com/blog/disabling-the-plymouth-boot-screen-in-ubuntu-20-04/)
- [Disable error report dialog](https://www.kevin-custer.com/blog/how-to-turn-off-the-error-report-dialog-in-ubuntu-20-04/)
- [Docker and Fedora 32](https://fedoramagazine.org/docker-and-fedora-32/)
- [Fedora: Use DNS over TLS](https://fedoramagazine.org/use-dns-over-tls/)
- [Configuration files in the environment.d/](https://www.freedesktop.org/software/systemd/man/latest/environment.d.html)

# Credits

- [Jared Hocutt labtop config](https://github.com/jaredhocutt/laptop)
