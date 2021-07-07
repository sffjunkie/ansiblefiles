# Laptop

Configuration of my laptop using Ansible

Uses 3 separate stages

1. Pre configuration
    * Creates a user with sudo privileges
    * Creates an `authorized_keys` file for the user to enable publickey login
    * Configures SSH to use a different port, disable root logins and disable password authentication
2. Configuration - The main configuration
3. Post configuration
    * Changes the firewall to use the updated SSH port and disable the old one.
      A sort of anti-lockout procedure.
    * Starts the display-manager

## Roles

The play uses roles in the `roles` folder and a set of common roles in the directory one level above this one.

The folowing roles are provided here

* development - Configures development environments by using the following roles
    * development_ansible - Configures an Ansible development environment
    * development_go - Configures a Golang development environment
    * development_ts - Configures a Typescript development environment
    * development_pyenv - Installs pyenv
    * development_python - Configures a Python development environment
    * development_rust - Configures a Rust development environment
* dotlocal_directories - Creates ${HOME}/.local directories
* python3_gobject - Install the Python gobject libraries. These are used by QTile
* x11 - Installs and configures X11. This includes
    * video driver
    * display manager - Currently lightdm
    * window manager - currently [QTile](http://www.qtile.org/)
<!-- * xdg_user_dirs - Configures XDG user directories -->
