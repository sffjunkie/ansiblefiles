#!/bin/sh
ansible-playbook prepost.yaml \
    --tags preconfigure \
    -e @../common/vars/secrets.yaml \
    --ask-vault-pass
