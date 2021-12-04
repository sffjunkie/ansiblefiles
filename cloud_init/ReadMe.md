# cloud-init-nocloud

> **Note**: This playbook only configures values useful for a Proxmox VM.

Builds a basic cloud-init nocloud data-source image (and the yaml files that
are used to generate the image so you can see what's defined.)

These images are used to perform initial configuration of a vendors cloud-init
enabled image. For example
[Ubuntu's images can be found here](https://cloud-images.ubuntu.com/) and
[Fedora's here](https://alt.fedoraproject.org/cloud/)

The image created follows the
[nocloud format ](https://cloudinit.readthedocs.io/en/latest/topics/datasources/nocloud.html)

There are 2 categories of info stored in the image

1. user - Allows configuration of user (name, password SSH keys etc)
2. meta - Metadata about the instance including network configuration

The metadata keys follow the EC2 metadata as [indicated here](https://cloudinit.readthedocs.io/en/latest/topics/datasources/nocloud.html#:~:text=Basically%2C%20user-data%20is%20simply%20user-data%20and%20meta-data%20is%20a%20yaml%20formatted%20file%20representing%20what%20you%E2%80%99d%20find%20in%20the%20EC2%20metadata%20service.)
and the EC2 metadata keys can be found [here](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instancedata-data-categories.html)
(though I think that not all keys listed will be relevant to cloud-init)

## Pre-requisites

Requires python3 apt package (e.g. `python3-apt` on Ubuntu)

## Script Info

The script has two required arguments

* `hostname` which is the host name contained within the generated image.
* `target` the target host name as defined in the inventiry

The second argument determines which stages of the cloud-init generation are to be run. These can be one of the following

* `config` - Creates the cloud-init configuration files
* `image` - Creates the configuration files and puts them into a cloud-init nnocloud image
* `copy` - Copies the resulting config files and image to the target host

### Options

* `-c | --config` - Specifies a name to be used as part of the cloud-init configuration files and image output by this script and playbook
* `-d | --date` - Specifies whether todays date is to be used as part of the cloud-init configuration files and image output by this script and playbook
* `-i | --inventory` - Specifies the location of the ansible inventory
* `-u | --user` - Specifies any extra user configuration information to be included
* `-m | --meta` - Specifies any extra meta configuration information to be included
* `-v | --verbose` - Displays extra information during the run.

## Secrets

* Secret variables used to create the image and configuration are read
  from the file

  Currently this file defines the following keys:

  * `config_name` - The name used to generate the configuration file name
  * `user_default` - The default user to create with the following information;
    `id`, `password`, `ssh_key`, `groups` (extra groups) and
    `sudo` (something like `ALL=(ALL:ALL) ALL`
    but see the `sudoers` man page for info)

* Secret variables used to copy the files to the target Proxmox server are
  read from `../common/vars/secrets.yaml` i.e. they are common to all
  playbooks

  > **Note**: The default cloud-init username/password match those defined the common file to enable configuration
    of cloud-init based images built with other playbooks in this repository.

These files are not stored in the Git repository.

### Passwords

The following command can be used to generate a hashed password

```
mkpasswd --method=SHA-512 --rounds=4096
```

The `mkpasswd` command is in the `whois` package and is installed by this playbook.
