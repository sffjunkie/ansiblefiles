# cloud-image

> **Note**: This playbook only configures values useful for a Proxmox VM.

Builds a basic cloud-init nocloud data-source image (and the yaml files that are used to generate the image)

The image created follows the
[nocloud format ](https://cloudinit.readthedocs.io/en/latest/topics/datasources/nocloud.html)

There are 2 categories of info stored in the image

1. user - Allows configuration of user (name, password SSH keys etc)
2. meta - Metadata about the instance including network configuration

The metadata keys follow the EC2 metadata as [described here](https://cloudinit.readthedocs.io/en/latest/topics/datasources/nocloud.html#:~:text=Basically%2C%20user-data%20is%20simply%20user-data%20and%20meta-data%20is%20a%20yaml%20formatted%20file%20representing%20what%20you%E2%80%99d%20find%20in%20the%20EC2%20metadata%20service.)
and the EC2 metadata keys can be found [here](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instancedata-data-categories.html)

<!-- Use the following to generate a password hash

    mkpasswd --method=SHA-512 --rounds=4096 -->
