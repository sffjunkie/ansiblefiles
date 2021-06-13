#!/bin/sh
config_path=$(realpath ../configfiles/output)
ansible-playbook build.yaml -e configfiles_path=${config_path} --ssh-ask-pass --become-ask-pass
