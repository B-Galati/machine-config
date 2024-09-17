# Usage

```bash
# Only required package, the rest is automatic
sudo apt update -y && sudo apt install -y make

# Set up everything
make install

# Install a given role
make install ARGS="-t docker"

# Force install of discord
make install ARGS="-t discord -e force_install=true}"

# Update everything on the machine
make update
```

# Ideas of some things to do manually 

- Configure TLP to optimize battery lifetime

- Initialize favorite apps:
```shell
 gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'alacritty.desktop', 'jetbrains-phpstorm-55be83e5-2bc4-4556-bef0-9a571ec27ac3.desktop', 'firefox-dev.desktop', 'google-chrome.desktop', 'enpass.desktop', 'slack.desktop', 'discord_discord.desktop', 'whatsapp.desktop', 'spotify.desktop', 'org.gnome.SystemMonitor.desktop', 'org.gnome.Characters.desktop', 'org.gnome.TextEditor.desktop']"
```

# References

- [Disable error report dialog](https://www.kevin-custer.com/blog/how-to-turn-off-the-error-report-dialog-in-ubuntu-20-04/)
- [Configuration files in the environment.d/](https://www.freedesktop.org/software/systemd/man/latest/environment.d.html)

# Credits

- [Jared Hocutt labtop config](https://github.com/jaredhocutt/laptop)
