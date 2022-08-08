# Usage

```bash
# Set up everything
make install

# Install a given role
make install ARGS="-t docker"

# Force install of discord
make install ARGS="-t discord -e '{"discord_force_install": true}'"

# Update everything on the machine
make update
```

# Ideas of some things to do manually 

- Configure TLP to optimize battery lifetime
- Add entry `tmpfs /tmp tmpfs defaults,size=1g 0 0` to `/etc/fstab`
- Consider HWE packages for Ubuntu
- Install [docker compose switch](https://github.com/docker/compose-switch) if needed
- Install (or enable) Gnome Extensions:
    - [User Themes](https://extensions.gnome.org/extension/19/user-themes/)
    - [Nothing to Say](https://extensions.gnome.org/extension/1113/nothing-to-say/)
    - [Sound Input & Output Device Chooser](https://extensions.gnome.org/extension/906/sound-output-device-chooser/)
    - [Applications Menu](https://extensions.gnome.org/extension/6/applications-menu/)
    - [Dash to Panel](https://extensions.gnome.org/extension/1160/dash-to-panel/)
    - [Launch new instance](https://extensions.gnome.org/extension/600/launch-new-instance/)

## Bépo and keyboard configuration

[source](https://bepo.fr/wiki/Console_GNU/Linux#Configuration_avanc.C3.A9e)
[Keyboard Wiki Debian](https://wiki.debian.org/fr/Keyboard)
[ArchLinux Wiki](https://wiki.archlinux.org/index.php/Keyboard_configuration_in_Xorg)

Switch keyboard manually

```bash
setxkbmap fr bepo
```

To re-configure the keyboard :

```bash
sudo dpkg-reconfigure keyboard-configuration
```

Update file `/etc/default/keyboard` :

```
XKBMODEL="tm2030USB-102"
XKBLAYOUT="fr,fr"
XKBVARIANT="bepo,"
XKBOPTIONS="grp:alt_caps_toggle"
```

# References

- [Disable Ubuntu snaps](https://www.kevin-custer.com/blog/disabling-snaps-in-ubuntu-20-04/)
- [Disable boot screen](https://www.kevin-custer.com/blog/disabling-the-plymouth-boot-screen-in-ubuntu-20-04/)
- [Disable error report dialog](https://www.kevin-custer.com/blog/how-to-turn-off-the-error-report-dialog-in-ubuntu-20-04/)
- [Docker and Fedora 32](https://fedoramagazine.org/docker-and-fedora-32/)
- [Fedora: Use DNS over TLS](https://fedoramagazine.org/use-dns-over-tls/)

# Credits

- [Jared Hocutt labtop config](https://github.com/jaredhocutt/laptop)
