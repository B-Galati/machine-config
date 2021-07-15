# Usage

```bash
# Requirements - Fedora
sudo dnf install -y make git
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf group upgrade --with-optional Multimedia

# Requirements - Ubuntu
sudo apt install -y make git

# Clone the repository 
git clone git@github.com:B-Galati/machine-config.git

# To configure local machine
make install
make install-force # To re-install ansible dependencies

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
    - [Applications Menu](https://extensions.gnome.org/extension/6/applications-menu/)
    - [Dash to Panel](https://extensions.gnome.org/extension/1160/dash-to-panel/)
    - [Launch new instance](https://extensions.gnome.org/extension/600/launch-new-instance/)
    - [User Themes](https://extensions.gnome.org/extension/19/user-themes/)

# References

- [Disable Ubuntu snaps](https://www.kevin-custer.com/blog/disabling-snaps-in-ubuntu-20-04/)
- [Disable boot screen](https://www.kevin-custer.com/blog/disabling-the-plymouth-boot-screen-in-ubuntu-20-04/)
- [Disable error report dialog](https://www.kevin-custer.com/blog/how-to-turn-off-the-error-report-dialog-in-ubuntu-20-04/)
- [Docker and Fedora 32](https://fedoramagazine.org/docker-and-fedora-32/)
- [Fedora: Use DNS over TLS](https://fedoramagazine.org/use-dns-over-tls/)

# Credits

- [Jared Hocutt labtop config](https://github.com/jaredhocutt/laptop)
