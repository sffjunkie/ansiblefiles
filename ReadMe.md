# Ansible Playbooks

* backup - Backup data from servers and laptop
* restore - Restore data to servers and laptop
* cloud_image_nocloud - Builds a basic cloud-init nocloud data-source image
* common - Common roles, plugins and vars
* config_files - Generates configuration files to be copied to the laptop
* container_machine - Configures a machine to manage containers i.e.
  docker/podman
* home_automation - Configures the home automation machine
* laptop - Configures the laptop
* machine - Common configuration for machines; either physical or virtual
* script_files - Bash/ZSH scripts to be copied to the laptop
* service_files - Creates the files needed to startup a service
* unifi - Configures a Unifi controller VM
* vars - Common ansible variable files
* vm_node - Configures a node to host virtual machines (currently Proxmox)

## Future

* ansiblehost - Configures a machine to manage these Ansible files run them
* autoinstall - Ubuntu Autoinstall

## License

These ansible files are under the MIT license

## Required Packages

nfs-common to mount NFS share

## Variables

The playbooks use various variables defined in ./common/vars/global.yaml

Of particular note are

* distribution - Converts `ansible_distribution` to lower case and removes
  spaces. This it to use as a filename to `include_tasks` from.

## Notes

* Comments like `# yaml-language-server: $schema=./[insert filename here]`
  are used to bypass YAML schema validation for the file within VS Code.

  This is because the YAML language server from RedHat automatically matches
  schemas to file names. So if we want to have a file `build.yaml` this
  would normally be recognized as a `Hammerkit YAML schema` and this throws
  up lots of errors as that's not what we're using and there's currently no
  other way to disable this.
