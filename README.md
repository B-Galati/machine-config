# Usage

```bash
# To configure local machine
make install

# To update everything on the machine
make update

# To install a particular role
make role ROLE=<role_name>
```

# Things to do manually 

- Remove Ubuntu report popup `sudo apt-get remove --purge apport`
- [Doc](http://richardbenjaminrush.com/keechallenge/) to set up keepass and U2F
- [Doc](https://support.yubico.com/support/solutions/articles/15000011356-ubuntu-linux-login-guide-u2f) to configure U2F on ubuntu.
- Consider HWE packages for Ubuntu: `linux-generic-hwe-18.04`, `xserver-xorg-hwe-18.04`
- Install Gnome Extensions:
    - [AppIndicator and KStatusNotifierItem Support](https://extensions.gnome.org/extension/615/appindicator-support/)
    - [Sound Input & Output Device Chooser](https://extensions.gnome.org/extension/906/sound-output-device-chooser/)
    - [Applications Menu](https://extensions.gnome.org/extension/6/applications-menu/)
    - [Dash to Panel](https://extensions.gnome.org/extension/1160/dash-to-panel/)
    - [Launch new instance](https://extensions.gnome.org/extension/600/launch-new-instance/)
    - [User Themes](https://extensions.gnome.org/extension/19/user-themes/)
    - [Nothing to Say](https://extensions.gnome.org/extension/1113/nothing-to-say/)
- Add entry `tmpfs /tmp tmpfs defaults,size=1g 0 0` to `/etc/fstab`
- L2TP https://github.com/nm-l2tp/network-manager-l2tp/wiki/Prebuilt-Packages#ubuntu
- Configure CPU Governors (Intégrer dans Gnome 40+ dans la partie power)
  - [ArchLinux Wiki - CPU frequency scaling](https://wiki.archlinux.org/title/CPU_frequency_scaling)
  - [Doc Ubuntu Wiki fr](https://doc.ubuntu-fr.org/cpu-frequtils)
  ```bash
  for i in {0..7}; do sudo cpufreq-set -g performance -c $i; done
  cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
  sudo vi /etc/default/cpufrequtils # to change default governor
  GOVERNOR="performance"
  ```
- Configurer TLP pour optimiser la durée de vie de la batterie
- [Laptop mode pour optimiser la conso](https://doc.ubuntu-fr.org/laptop-mode-tools)

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
