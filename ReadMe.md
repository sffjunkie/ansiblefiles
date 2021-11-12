# Ansible Playbooks

* backup - Backup data from servers and laptop
* restore - Restore data to servers and laptop
* cloud_image - Builds a basic cloud-init nocloud data-source image
* common - Common roles, plugins and vars
* config_files - Generates laptop configuration files
* container_machine - Configures a machine to manage containers i.e. docker/podman
* home_automation - Configures the home automation machine
* laptop - Configures the laptop
* machine - Common configuration for VMs
* roles - Common roles
* script_files - Bash/ZSH scripts to be copied to the laptop
* service_files - Creates the files needed to startup a service
* unifi - Configures a Unifi controller VM
* vars - Common ansible variable files
* vm_node - Configures a node to host virtual machines (currently Proxmox)
* service_files - Files to recreate a service

## Future

* ansiblehost - Configures a machine to manage these Ansible files run them
* autoinstall - Ubuntu Autoinstall

config file templates -> config files
docker compose templates -> docker compose files


## Packages

nfs-common to mount NFS share
