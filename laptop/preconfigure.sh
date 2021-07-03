#!/bin/sh
ansible-playbook prepost.yaml \
    --tags preconfigure \
    -e @../vars/secrets.yaml \
    --ask-vault-pass
