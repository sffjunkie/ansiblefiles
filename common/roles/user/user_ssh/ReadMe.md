# user-ssh

Create a `.ssh` directory for a user and an authorized keys file.

Reads information from a user variable whioch needs the following information

* `id` - The id to login to the system
* `ssh_public_key_file` - The name of the file in the user's `.ssh`
  directory on the current machine that contains the local user's public SSH key.
  The contents will get copied to the `authorized_keys` file in the created
  user's .ssh directory
