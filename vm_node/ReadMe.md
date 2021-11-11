# VM Nodes Playbook

VM Nodes are physical nodes which manage virtual machines e.g. Proxmox

* Configures a VM node.
* Clones a VM
  * Need to truncate /etc/machine-id to get new ip address `sudo truncate -s 0 /etc/machine-id`
* Creates a new VM
* Backs up the VM node

Currently only Proxmox nodes are supported.

For Proxmox nodes the following roles are run

* configure_apt_sources - Adds the PVE no subscription repository and disables the enterprise repository
* darkmode - Configures dark mode using the script at https://github.com/Weilbyte/PVEDiscordDark
* no_valid_subscription - Removes the 'No Valid Subscription' warning on login


## Resize VM disk

```
qm resize <vmid> scsi0 +20G
```

Resize disk in `cfdisk`

```
pvresize /dev/sda3
lvresize -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
resize2fs /dev/ubuntu-vg/ubuntu-lv
```
