#!/bin/bash
source ../common/script/functions.sh

INVENTORY="../inventory"
CONFIG_NAME=""

_version="0.1.0"


help() {
    echo "Cloud-init configuration / nocloud data-source image creator"
    echo
    echo "Usage:"
    echo -n "  $ "
    script; param "hostname "; param "target "; param "[stage]"
    echo
    echo
    echo "Where"
    echo -n "  "; param "hostname"; echo " = the hostname of the machine to be created."
    echo -n "  "; param "target"; echo " = the name of a host from the inventory to copy the"
    echo "  generated files to."
    echo -n "  "; param "stage"; echo " = one of config, image or copy"
    echo
    echo "    config - Generates YAML user and meta config files"
    echo "    image - Generates the configs and a nocloud image"
    echo "    copy - Copies the generated configs and images to the target"
    echo
    echo "  If no stage is specified then all stages will run"
    echo
    echo "Options:"
    echo "  -h | --help       Show this help text"
    echo
    echo "  -n | --name     Name used in the output config and image file names"
    echo "  -d | --date       Use date in the output config and image file names"
    echo "  -i | --inventory  Path to the ansible inventory (default ${INVENTORY})"
    echo "                    (or set the INVENTORY environment variable when"
    echo "                    calling this script)"
    echo "  -u | --user       Extra user configuration"
    echo "  -m | --meta       Extra meta configuration"
    echo "  -v | --verbose    Display information about the script"
    echo
    echo "  -V | --version    Display version information"
    echo "  --no-color        Don't use colored output"
    echo "                    (or set the NO_COLOR environment variable when"
    echo "                    calling this script)"
    echo "  --force-color     Force the use of colored output"
    echo "                    (overrides the NO_COLOR environment variable)"
    echo
    echo "Extra user/meta configuration can either be a yaml string or a"
    echo "the name of a file preceeded with an '@' symbol that contains yaml"
    echo "e.g. '@afile.yaml'"
    exit 0
}

TEMP=$(getopt --options 'hn:di:u:m:vV' \
    --longoptions 'help,name:,date,inventory:,user:,meta:,no-color,force-color,verbose,version' -- "$@")
eval set -- "${TEMP}"

config_name="$CONFIG_NAME"
use_date="false"
inventory="$INVENTORY"
user_config=""
meta_config=""
verbose=0
while true ; do
    case "$1" in
        -h|--help) show_help=1; shift ;;

        -c|--config) config_name=$2; shift; shift ;;
        -d|--date) use_date="true"; shift ;;
        -i|--inventory) inventory=$2; shift; shift ;;
        -u|--user) user_config=$2; shift; shift ;;
        -m|--meta) meta_config=$2; shift; shift ;;

        -v|--verbose) (( verbose="$verbose" + 1 )); shift ;;
        -V|--version) script; echo " version ${_version}" ; exit 0 ;;
        --no-color) NO_COLOR=1; shift ;;
        --force-color) FORCE_COLOR=1; shift ;;
        *) shift; break ;;
    esac
done

COLOR=1
[[ ! -t 1 ]] && COLOR=0
[[ "${TERM}" == "dumb" ]] && COLOR=0

[[ -n "${NO_COLOR}" ]] && COLOR=0
[[ -n "${FORCE_COLOR}" ]] && COLOR=1

[[ "$#" -eq 0 || ${show_help} -eq 1 ]] && help

info "Using defaults: config_name=${config_name}, inventory=${inventory}" 2

hostname="$1"
shift
[[ -z "$hostname" ]] && error "No hostname provided"

target="$1"
shift
[[ -z "$target" ]] && error "No target machine provided"
msg="target should be one of config, image or copy, are you missing a correct target"
[[ "$target" == "config" || "$target" == "image" || "$target" == "copy" ]] && warning "$msg"
# if ! ansible-inventory --inventory="$inventory" --host="$hostname" &> /dev/null; then
#     error "Unable to find machine '$target' in the inventory."
# fi

stage="$1"
if [ -n "$stage" ]
then
    case "$stage" in
        config|image|copy) ;;
        *) error "Invalid stage: Must be one of 'config', 'image' or 'copy'" ;;
    esac
fi
shift

info "Building configuration for '${hostname}' on host '${target}'"
info "Running stage '${stage:-all}'"

declare -a arg_list
[[ -n "${config_name}" ]] && arg_list+=("-e cli_config_name=$config_name")
[[ $verbose != 0 ]] && arg_list+=("-e verbose=${verbose}")

case "$stage" in
    config)
        ansible-playbook build.yaml \
        --inventory="${inventory}" \
        -e cli_use_date="$use_date" \
        -e cli_hostname="$hostname" \
        -e extra_user_config="$user_config" \
        -e extra_meta_config="$meta_config" \
        "${arg_list[@]}" \
        "$@" \
        --skip-tags=image,copy
    ;;

    image)
        ansible-playbook build.yaml \
        --inventory="${inventory}" \
        -e cli_use_date="$use_date" \
        "${arg_list[@]}" \
        "$@" \
        --skip-tags=config,copy
    ;;

    copy)
        ansible-playbook build.yaml \
        --inventory="${inventory}" \
        -e cli_use_date="$use_date" \
        "${arg_list[@]}" \
        "$@" \
        --skip-tags=config,image
    ;;

    *)
        ansible-playbook build.yaml \
        --inventory="${inventory}" \
        -e cli_use_date="$use_date" \
        -e cli_hostname="$hostname" \
        -e extra_user_config="$user_config" \
        -e extra_meta_config="$meta_config" \
        "${arg_list[@]}" \
        "$@"
    ;;
esac
