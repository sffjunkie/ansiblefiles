# Ansible Playbooks

* _ansiblehost_ _(Future)_ - Configures a machine to manage these Ansible
  files run them
* common - Common roles, plugins and vars
* configfiles - Generates laptop configuration files
* laptop - Configures the laptop
* machine - Common configuration for VMs
* roles - Common roles
* scriptfiles - Bash/ZSH scripts to be copied to the laptop
* unifi - Configures a Unifi controller VM
* vars - Common ansible variable files
* vmhost - Configures VM hosts machines (currently Proxmox)


## laptop

Configures the laptop, generates the configuration files and copies them to the laptop.

The laptop config is done in 3 steps

1. preconfigure - adds users, copies SSH keys, configures sudo and changes the
   SSH port number
2. configure - the main configuration
3. postconfigure - Updates the firewall to allow the new port number and deny
   the default port then reboots the machine

## laptop.yaml

The `laptop.yaml` host_vars file determines waht gets installed on the laptop.

# License

These playbooks are under the CC-BY-4.0 license






system
    flatpak

applications
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
