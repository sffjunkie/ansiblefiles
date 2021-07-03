#!/bin/sh
ansible-playbook prepost.yaml \
    --tags postconfigure \
    -e @../vars/secrets.yaml \
    --ask-vault-pass
