# Machine

Configures a (virtual) machine.

Machines need the default_user account to be created

## Pre-configuration

* Sets the hostname
* Installs an SSH server
* Hardens the ssh server configuration and changes the port.
* Adds system users i.e. those allowed to use sudo
* Updates `/etc/issue` and `/etc/issue.net` files

password = encrypted password.
Use `mkpasswd --method=SHA-512 --rounds=4096` to encrypt a string
