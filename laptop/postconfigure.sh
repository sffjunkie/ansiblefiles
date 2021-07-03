#!/bin/sh
ansible-playbook preconfigure.yaml \
    -e @../vars/secrets.yaml \
    --ask-vault-pass
