# VMHost Playbook

Configures a VM host.

Currently only Proxmox hosts are supported.

Runs the following roles

* configure_updates - Adds the PVE no subscription repository and disables the enterprise repository
* darkmode - Configures dark mode using the script at https://github.com/Weilbyte/PVEDiscordDark
* no_valid_subscription - Removes the 'No Valid Subscription' warning on login
