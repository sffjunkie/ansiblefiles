# VM Nodes Playbook

* Configures a VM node.
* Clones a VM
* Creates a new VM

Currently only Proxmox nodes are supported.

For Proxmox nodes the following roles are run

* configure_apt_sources - Adds the PVE no subscription repository and disables the enterprise repository
* darkmode - Configures dark mode using the script at https://github.com/Weilbyte/PVEDiscordDark
* no_valid_subscription - Removes the 'No Valid Subscription' warning on login
