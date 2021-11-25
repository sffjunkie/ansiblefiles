#!/bin/sh
ansible-playbook configure.yaml \
    -i ../inventory \
    -e @../common/vars/secrets.yaml \
    -e configfiles_path=$(realpath ../configbuild) \
    -e scriptfiles_path=$(realpath ../scriptfiles) "$@"
# -e scriptfiles_path=$(realpath ../scriptfiles) \
# --ask-vault-pass
