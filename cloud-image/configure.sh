#!/bin/sh
ansible-playbook configure.yaml -i ../inventory.yaml "$@"
