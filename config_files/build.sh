#!/bin/sh
# [ -f requirements.yaml ] && ansible-galaxy install -r requirements.yaml
ansible-playbook build.yaml \
    -i ../inventory \
    -e @../common/vars/secrets.yaml \
    "$@"
    # -e scriptfiles_path=$(realpath ../scriptfiles) \
    # --ask-vault-pass
