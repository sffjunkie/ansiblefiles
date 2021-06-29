#!/bin/sh
ansible-playbook main.yaml \
    -e @../vars/secrets.yaml \
    -e configfiles_path=$(realpath ../configfiles/output) \
    -e scriptfiles_path=$(realpath ../scriptfiles) \
    -u sdk --ask-become-pass
