#!/bin/sh
ansible-playbook configure.yaml \
    -e @../common/vars/secrets.yaml \
    -e configfiles_path=$(realpath ../configfiles/output) \
    -e scriptfiles_path=$(realpath ../scriptfiles) "$@"
    # -e scriptfiles_path=$(realpath ../scriptfiles) \
    # --ask-vault-pass
