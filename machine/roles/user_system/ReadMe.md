# user_system

Configures a single user for access to the system by

  * Adding the user
  * Adding the user to the sudoers list
  * Configuring ssh

Uses the `users_common` variable to define what to configure.

`users_common` is list of information about each user on the system.

Each user's information is a dictionary with the following information

* `id` - Login id
* `name` - User's name
* `password` - An [encrypted password](https://docs.ansible.com/ansible/latest/reference_appendices/faq.html#how-do-i-generate-encrypted-passwords-for-the-user-module)
* `public_key` - The user's public key for SSH
* `groups` - Additional groups the user should belong to
* `sudo` - The entry to add to a file in `/etc/sudoers.d` to configure
  `sudo` priviliges

i.e. users = list[dict]

> :warning: This information should be kept secret.
