#!/bin/sh
ansible-playbook main.yaml -e @../common/vars/secrets.yaml -i ../inventory
