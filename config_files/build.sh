#!/bin/sh
[ -f requirements.yaml ] && ansible-galaxy install -r requirements.yaml
ansible-playbook build.yaml \
    -e @../vars/secrets.yaml \
    "$@"
    # -e scriptfiles_path=$(realpath ../scriptfiles) \
    # --ask-vault-pass
