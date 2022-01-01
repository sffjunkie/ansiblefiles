#!/bin/bash
source ../common/script/functions.sh

INVENTORY=../inventory

_version="0.1.0"

help() {
    echo "Preconfigure a machine with ansible"
    echo
    echo -n "usage: "; script; param "machine"; echo
    echo
    echo -n "Where "; param "machine"; echo " is a host name from the 'machine' group in the"
    echo "ansible inventory (${inventory})"
    echo
    echo "options:"
    echo "  -a | --all        Pre-configure all hosts in the 'machine' group"
    echo "  -u | --users      File containing additional users to create"
    echo "  -i | --inventory  Path to the ansible inventory (default ${INVENTORY})"
    echo "                    (or set the INVENTORY environment variable when"
    echo "                    calling this script)"
    echo
    echo "  -h | --help       Show this help text"
    echo "  -V | --version    Display version information"
    echo "  --no-color        Don't use colored output"
    echo "                    (or set the NO_COLOR environment variable when"
    echo "                    calling this script)"
    echo "  --force-color     Force the use of colored output"
    echo "                    (overrides the NO_COLOR environment variable)"
    echo "                    calling this script)"
}

show_help=0
all=0
inventory="${INVENTORY}"
user_file=
verbose=0
if [[ "$#" -eq 0 ]]; then
    show_help=1
else
    TEMP=$(getopt --options 'hai:u:vV' \
        --longoptions 'help,all,inventory:,users:,verbose,version' -- "$@")
    eval set -- "${TEMP}"

    while true ; do
        case "$1" in
            -a|--all) all=1; shift ;;
            -i|--inventory) inventory=$2; shift; shift ;;
            -u|--user-file) user_file=$2; shift; shift ;;

            -h|--help) show_help=1; shift ;;
            -v|--verbose) (( verbose="$verbose" + 1 )); shift ;;
            -V|--version) echo "${_version}" ; exit 0 ;;
            --no-color) NO_COLOR=0; shift ;;
            --force-color) FORCE_COLOR=1; shift ;;
            *) shift; break ;;
        esac
    done
fi

COLOR=1
[[ ! -t 1 ]] && COLOR=0
[[ "${TERM}" == "dumb" ]] && COLOR=0
[[ -n "${NO_COLOR}" ]] && COLOR=0
[[ -n "${FORCE_COLOR}" ]] && COLOR=1

[[ ${show_help} -eq 1 ]] && help && exit 0

machine=$1
shift
[[ -z ${machine} && ${all} != 1 ]] && error "machine parameter missing" && exit 1

declare -a arg_list
[[ -n ${machine} && ${all} != 1 ]] && arg_list+=("--limit=${machine}")
[[ -n ${user_file} ]] && arg_list+=("-e users_file=${user_file}")
[[ $verbose != 0 ]] && arg_list+=("-e verbose=${verbose}")

ansible-playbook preconfigure.yaml \
    --inventory "${inventory}" \
    "${arg_list[@]}" \
    "$@"
