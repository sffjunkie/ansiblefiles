#!/bin/sh
ansible-playbook main.yaml \
    -e configfiles_path=$(realpath ../configfiles/output) \
    -e scriptfiles_path=$(realpath ../scriptfiles) \
    --ssh-ask-pass --become-ask-pass
