# Installing on OSX

## Installing

It requires Docker 17.12+.

### Installing tuntap

```
brew tap caskroom/cask
brew cask install tuntap
```

If you see this error while installing TunTap:

```
Error: Command failed to execute!

==> Failed command:
/usr/bin/sudo -E -- /usr/sbin/installer -pkg /usr/local/Caskroom/tuntap/20150118/tuntap_20150118.pkg -target /

==> Standard Output of failed command:
installer: Package name is TunTap Installer package
installer: Installing at base path /
installer: The install failed (The Installer encountered an error that caused the installation to fail.
```

you'll need to allow the installation on `System Preferences > Security > General`.

### Clone the project:

```
git clone git@github.com:beautybrands/consul.git && cd consul
```

### Installing interface

```
./docker-tuntap-osx/sbin/docker_tap_install.sh
```

### Turn up the tuntap interface

This command MUST run every Docker restart:

```
./start_osx.sh
```

### Add the local DNS to MAC

Set 127.0.0.1 to DNS in Network Manager

## Debugging

To see a list of useful commands:
https://github.com/AlmirKadric-Published/docker-tuntap-osx/issues/7#issuecomment-350550862

### To list routes:

```
netstat -rn
```

### Enter HiperKit:

```
screen ~/Library/Containers/com.docker.docker/Data/com.docker.driver.amd64-linux/tty
```
