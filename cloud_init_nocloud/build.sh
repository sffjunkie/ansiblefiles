#!/bin/bash

__version="0.1.0"

# Defaults
config_name=""
secrets_file="../common/vars/secrets.yaml"
inventory="../inventory"

error() {
    [ -z "$2" ] && EC=1 || EC="$2"
    [ -z "${NO_COLOR}" ] && tput setaf 1
    echo -n "Error:" 1>&2
    [ -z "${NO_COLOR}" ] && tput sgr0
    echo " $1" 1>&2
    exit $EC
}

warning() {
    [ -z "${NO_COLOR}" ] && tput setaf 3
    echo -n "Warning:" 1>&2
    [ -z "${NO_COLOR}" ] && tput sgr0
    echo " $1" 1>&2
}

info() {
    [ $VERBOSE -lt ${2:-1} ] && return
    [ -z "${NO_COLOR}" ] && tput setaf 6
    echo -n "Info:" 1>&2
    [ -z "${NO_COLOR}" ] && tput sgr0
    echo " $1" 1>&2
}

help() {
    echo "Cloud-init configuration / nocloud data-source image creator"
    echo
    echo "Usage:"
    echo "  $ $(basename $0) hostname target [stage]"
    echo
    echo "Where"
    echo "    * hostname is the hostname of the machine to be created."
    echo "    * target is the name of a host from the inventory to copy the"
    echo "      generated files to."
    echo "    * stage is one of config, image or copy"
    echo
    echo "  config - Generates YAML user and meta config files"
    echo "  image - Generates the configs and a nocloud image"
    echo "  copy - Copies the generated configs and images to the target"
    echo
    echo "If no stage is specified then all stages will run"
    echo
    echo "Options:"
    echo "  -h | --help       Show this help text"
    echo "  -c | --config     Name used in the output config and image file names"
    echo "  -d | --date       Use date in the output config and image file names"
    echo "  -i | --inventory  Path to the inventory"
    echo "  -u | --user       Extra user configuration"
    echo "  -m | --meta       Extra meta configuration"
    echo "  -s | --secrets    Path to a file containing information"
    echo "  -v | --verbose    Display information about the script"
    echo "  --version         Display version information"
    echo "  --no-color        Don't use colored output"
    echo
    echo "Extra user/meta configuration can either be a yaml string or a"
    echo "the name of a file preceeded with an '@' symbol that contains yaml"
    echo "e.g. '@afile.yaml'"
    exit 0
}

[ "$#" -eq 0 ] && help

TEMP=$(getopt --options 'hc:di:u:m:s:v' --longoptions 'help,config:,date,inventory:,user:,meta:,secrets:,verbose,no-color,version' -- "$@")
eval set -- "${TEMP}"

CONFIG_NAME="$config_name"
USE_DATE="false"
INVENTORY="$inventory"
USER_CONFIG=""
META_CONFIG=""
SECRETS_FILE="${secrets_file}"
VERBOSE=0
while true ; do
    case "$1" in
        -h|--help) help ;;
        -c|--config) CONFIG_NAME=$2; shift; shift ;;
        -d|--date) USE_DATE="true"; shift ;;
        -i|--inventory) INVENTORY=$2; shift; shift ;;
        -u|--user) USER_CONFIG=$2; shift; shift ;;
        -m|--meta) META_CONFIG=$2; shift; shift ;;
        -s|--secrets) SECRETS_FILE=$2; shift; shift ;;
        -v|--verbose) VERBOSE=$(( $VERBOSE + 1 )); shift ;;
        --no-color) NO_COLOR=1; shift ;;
        --version) echo "build.sh version ${__version}" ; exit 0 ;;
        *) shift; break ;;
    esac
done

[ ! -t 1 ] && NO_COLOR=1
[ "$TERM" == "dumb" ] && NO_COLOR=1

info "Using defaults: config_name=${config_name}, secrets_file=${secrets_file}, inventory=${inventory}" 2

hostname="$1"
shift
[ -z "$hostname" ] && error "No hostname provided"

target="$1"
shift
[ -z "$target" ] && error "No target machine provided"
msg="target is one of config, image or copy are you missing a correct target"
[ "$target" == "config" ] || [ "$target" == "image" ] || [ "$target" == "copy" ] && warning "$msg"
# if ! ansible-inventory -i "$inventory" --host="$hostname" &> /dev/null; then
#     error "Unable to find machine '$target' in the inventory."
# fi

info "Building configuration for '${hostname}' on host '${target}'"

stage="$1"
if [ ! -z "$stage" ]
then
    case "$stage" in
        config|image|copy) ;;
        *) error "Invalid stage: Must be one of 'config', 'image' or 'copy'" ;;
    esac
fi
shift

info "Using secrets file '${SECRETS_FILE}'"
info "Running stage '${stage:-all}'"

exit

declare -a arglist
[ ! -z "$CONFIG_NAME" ] && arglist+=("-e cli_config_name=$CONFIG_NAME")

case "$stage" in
    config)
        ansible-playbook build.yaml -i ../inventory \
        "${arglist[@]}" \
        -e "@${SECRETS_FILE}" \
        -e cli_use_date="$USE_DATE" \
        -e cli_hostname="$hostname" \
        -e extra_user_config="$USER_CONFIG" \
        -e extra_meta_config="$META_CONFIG" \
        --skip-tags=image,copy
    ;;

    image)
        ansible-playbook build.yaml -i ../inventory \
        "${arglist[@]}" \
        -e "@${SECRETS_FILE}" \
        -e cli_use_date="$USE_DATE" \
        --skip-tags=config,copy
    ;;

    copy)
        ansible-playbook build.yaml -i ../inventory \
        "${arglist[@]}" \
        -e "@${SECRETS_FILE}" \
        -e cli_use_date="$USE_DATE" \
        --skip-tags=config,image
    ;;

    *)
        ansible-playbook build.yaml -i ../inventory \
        "${arglist[@]}" \
        -e "@${SECRETS_FILE}" \
        -e cli_use_date="$USE_DATE" \
        -e cli_hostname="$hostname" \
        -e extra_user_config="$USER_CONFIG" \
        -e extra_meta_config="$META_CONFIG"
    ;;
esac
exit 0
