#!/bin/sh
ansible-playbook configure.yaml \
    -e @../common/vars/secrets.yaml
