#!/bin/sh
[ -f requirements.yaml ] && ansible-galaxy install -r requirements.yaml
ansible-playbook build.yaml
