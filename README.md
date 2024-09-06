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
- Consider HWE packages for Ubuntu
- Install (or enable) Gnome Extensions:
    - [Applications Menu](https://extensions.gnome.org/extension/6/applications-menu/)
    - [Dash to Panel](https://extensions.gnome.org/extension/1160/dash-to-panel/)
    - [Launch new instance](https://extensions.gnome.org/extension/600/launch-new-instance/)
    - [Bluetooth Quick Connect ](https://extensions.gnome.org/extension/1401/bluetooth-quick-connect/)
- Customize other Gnome settings:

```shell
gsettings set org.gnome.desktop.interface text-scaling-factor 1.25
gsettings set org.gnome.TextEditor custom-font 'JetBrains Mono 13'
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrains Mono 13'
```



# References

- [Disable Ubuntu snaps](https://www.kevin-custer.com/blog/disabling-snaps-in-ubuntu-20-04/)
- [Disable boot screen](https://www.kevin-custer.com/blog/disabling-the-plymouth-boot-screen-in-ubuntu-20-04/)
- [Disable error report dialog](https://www.kevin-custer.com/blog/how-to-turn-off-the-error-report-dialog-in-ubuntu-20-04/)
- [Docker and Fedora 32](https://fedoramagazine.org/docker-and-fedora-32/)
- [Fedora: Use DNS over TLS](https://fedoramagazine.org/use-dns-over-tls/)

# Credits

- [Jared Hocutt labtop config](https://github.com/jaredhocutt/laptop)
