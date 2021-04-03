# Usage

```bash
# Fedora
sudo dnf install -y make git

# Ubuntu
sudo apt install -y make git

git clone git@github.com:B-Galati/machine-config.git
cd machine-config
make install
```

# Things to do manually 

- Remove Ubuntu report popup `sudo apt-get remove --purge apport`
- [Doc](http://richardbenjaminrush.com/keechallenge/) to set up keepass and U2F
- [Doc](https://support.yubico.com/support/solutions/articles/15000011356-ubuntu-linux-login-guide-u2f) to configure U2F on ubuntu.

# References

- [Disable Ubuntu snaps](https://www.kevin-custer.com/blog/disabling-snaps-in-ubuntu-20-04/)
- [Disable boot screen](https://www.kevin-custer.com/blog/disabling-the-plymouth-boot-screen-in-ubuntu-20-04/)
- [Disable error report dialog](https://www.kevin-custer.com/blog/how-to-turn-off-the-error-report-dialog-in-ubuntu-20-04/)
- [Docker and Fedora 32](https://fedoramagazine.org/docker-and-fedora-32/)
- [Fedora: Use DNS over TLS](https://fedoramagazine.org/use-dns-over-tls/)

# Credits

- [Jared Hocutt labtop config](https://github.com/jaredhocutt/laptop)
