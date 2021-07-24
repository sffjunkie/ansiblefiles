#!/bin/sh
ansible-playbook configure.yaml \
    -e @./vars/secrets.yaml "$@"
    # --ask-vault-pass
