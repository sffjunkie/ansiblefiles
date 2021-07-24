#!/bin/sh
ansible-playbook proxmox.yaml \
    -e @./vars/secrets.yaml "$@"
    # --ask-vault-pass
