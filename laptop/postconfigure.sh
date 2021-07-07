#!/bin/sh
ansible-playbook prepost.yaml \
    --tags postconfigure \
    -e @../common/vars/secrets.yaml \
    --ask-vault-pass
