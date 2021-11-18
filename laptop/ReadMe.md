# Laptop

Configuration of my laptop using Ansible

Uses 3 separate stages

1. Pre configuration
    * Creates a user with sudo privileges
    * Creates an `authorized_keys` file for the user to enable SSH publickey login
    * Configures SSH to use a different port, disable root logins and disable password authentication
2. Configuration - The main configuration
3. Post configuration
    * Changes the firewall to use the updated SSH port and disable the old one.
      A sort of anti-lockout procedure.
    * Starts the display-manager

Configuration info is stored as an inventory host var

## Roles

The play uses roles in the `roles` folder and a set of common roles in the directory one level above this one.

The folowing roles are provided here

* application -  Install and configure applications
    * [`alacritty`](./roles/application/alacritty) - Alacritty Terminal
    * [`bat`](./roles/application/bat) - The `cat` replacement (`batcat` on Ubuntu)
    * [`exa`](./roles/application/exa) - The `ls` replacement
    * [`oomox`](./roles/application/oomox) - X11 compositor
    * [`picom`](./roles/application/picom) - X11 compositor
    * [`vagrant`](./roles/application/vagrant) - HashiCorp Vagrant
    * [`vscode`](./roles/application/vscode) - Microsoft Visual Studio Code
* `avatar` - Configures the avatar for the display manager login screen
* `base16_shell` - Installs [`base16_shell`](https://github.com/chriskempson/base16-shell) and
   [`base16-shell-preview`](https://pypi.org/project/base16-shell-preview/)
* development - Configures development environments by using the following roles
    * [`dev_ansible`](./roles/development/dev_ansible) - Configures an Ansible development environment
    * [`dev_go`](./roles/development/dev_go) - Configures a Golang development environment
    * [`dev_gtk_theme`](./roles/development/dev_gtk_theme) - Configures a Gtk Theme development environment
    * [`dev_haskell`](./roles/development/dev_haskell) - Configures a Haskell development environment
    * [`dev_typescript`](./roles/development/dev_typescript) - Configures a Typescript development environment
    * [`dev_pyenv`](./roles/development/dev_pyenv) - Installs pyenv
    * [`dev_python`](./roles/development/dev_python) - Configures a Python development environment
    * [`dev_rust`](./roles/development/dev_rust) - Configures a Rust development environment
* `dotdirs` - Creates `${HOME}/.*` directories
* `ohmyzsh` - Installs Oh-My-Zsh
* `python3_gobject` - Install the Python gobject libraries. These are used by QTile
<!--
* theme - Install and manage themes
    * `theme_arc` - Installs the [Gtk Arc Theme](https://github.com/horst3180/arc-theme)
    * `theme_get_set_theme` - Configures Gtk to use the theme.
    * `theme_install` - Installs a theme
-->
* `x11` - Installs and configures X11. This includes
    * video driver
    * display manager - Currently lightdm
    * window manager - currently [QTile](http://www.qtile.org/)
<!-- * xdg_user_dirs - Configures XDG user directories -->


<!--
system
    flatpak

application
    alacritty
    base16-shell
    bat
    exa
    picom
    vagrant

development

themes

shell
    zsh
    ohmyzsh
development
x11

playbook
    aliases
    copyconfig
-->
