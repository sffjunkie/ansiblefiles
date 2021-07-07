# Ansible Playbooks

* _ansiblehost_ _(Future)_ - Configures a machine to manage these Ansible
  files run them
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

## vars directory

The vars directory contains the following files that can be edited to determine what
gets installed.

* laptop.yaml - configures my laptop
* development.yaml - configures development environments on the laptop

The other files hold variables used within the playbooks

# License

These playbooks are under the CC-BY-4.0 license
