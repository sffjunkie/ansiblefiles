#!/bin/bash

# Defaults
config_name=""
secrets="../common/vars/secrets.yaml"
inventory="../inventory"

error() {
    [ -t 1 ] && tput setaf 1
    echo -n "Error:" 1>&2
    [ -t 1 ] && tput sgr0
    echo " $1" 1>&2
    exit 1
}

help() {
    echo "Cloud-init configuration / nocloud data-source image creator"
    echo
    echo "usage: $(basename $0) machine_name [stage]"
    echo
    echo "Where machine_name is the name of the machine from the inventory to configure."
    echo "If the machine_name is found in the inventory "
    echo
    echo "and stage is one of config, image or copy, or empty to run all satges"
    echo
    echo "  config - Generates YAML user and meta config files"
    echo "  image - Generates the configs and a nocloud image"
    echo "  copy - Copies the generated configs and images to the host"
    echo
    echo "If no stage is specified then all stages will run"
    echo
    echo "options:"
    echo "  -h | --help       Show this help text"
    echo "  -c | --config     Name used in the output config and image file names"
    echo "  -d | --date       Use date in the output config and image file names"
    echo "  -i | --inventory  Path to the inventory"
    echo "  -u | --user       Extra user configuration"
    echo "  -m | --meta       Extra meta configuration"
    echo
    echo "Extra user/meta configuration can either be a yaml string or a"
    echo "the name of a a file that contains yaml preceeded with an '@' symbol"
    echo "e.g. '@afile.yaml'"
    exit 0
}

TEMP=$(getopt --options 'hc:di:u:m:' --longoptions 'help,config:,date,inventory:,user:,meta:' -- "$@")
eval set -- "${TEMP}"

CONFIG_NAME="$config_name"
USE_DATE=0
INVENTORY="$inventory"
USER_CONFIG=""
META_CONFIG=""
while true ; do
    case "$1" in
        -h|--help) help ;;
        -c|--config) CONFIG_NAME=$2; shift; shift ;;
        -d|--date) USE_DATE=1; shift ;;
        -i|--inventory) INVENTORY=$2; shift; shift ;;
        -u|--user) USER_CONFIG=$2; shift; shift ;;
        -m|--meta) META_CONFIG=$2; shift; shift ;;
        *) shift; break ;;
    esac
done

badstage() {
    error "Invalid stage: Must be one of 'config', 'image' or 'copy'" 1>&2
}

nohostname() {
    error "No hostname provided" 1>&2
}

hostname="$1"
[[ -z "$hostname" ]] && nohostname
if ! ansible-inventory -i "$inventory" --host="$hostname" &> /dev/null; then
    error "Unable to find host '$hostname' in the inventory."
fi
shift

stage="$1"
if [ ! -z "$stage" ]
then
    case "$stage" in
        config|image|copy) ;;
        *) badstage ;;
    esac
fi
shift

case "$stage" in
    config)
        ansible-playbook build.yaml -i ../inventory \
        -e cli_hostname="$hostname" \
        -e cli_config_name="$CONFIG_NAME" \
        -e cli_use_date=$USE_DATE \
        -e extra_user_config="$USER_CONFIG" \
        -e extra_meta_config="$META_CONFIG" \
        --skip-tags=image,copy "$@"
    ;;

    image)
        ansible-playbook build.yaml -i ../inventory \
        -e cli_config_name="$CONFIG_NAME" \
        --skip-tags=copy "$@"
    ;;

    copy)
        ansible-playbook build.yaml -i ../inventory \
        -e @../common/vars/secrets.yaml \
        -e cli_config_name="$CONFIG_NAME" \
        --skip-tags=config,image "$@"
    ;;

    *)
        ansible-playbook build.yaml -i ../inventory \
        -e @../common/vars/secrets.yaml \
        -e cli_config_name="$CONFIG_NAME" \
        -e extra_user_config="$USER_CONFIG" \
        -e extra_meta_config="$META_CONFIG" \
        "$@"
    ;;
esac
