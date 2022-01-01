#!/bin/bash
source ../common/script/functions.sh

INVENTORY=../inventory

_version="0.1.0"

help() {
    echo "usage: $(basename $0) [options]"
    echo
    echo "Install the qemu agent on a machine"
    echo
    echo "options:"
    echo "  -h | --help       Show this help text"
    echo
    echo "  -i | --inventory  Path to the ansible inventory (default ${INVENTORY})"
    echo "                    (or set the INVENTORY environment variable when"
    echo "                    calling this script)"
    echo "  -l | --limit      Limit to a subset of hosts matching a pattern"
    echo "  -V | --version    Display version information"
    echo "  --no-color        Don't use colored output"
    echo "                    (or set the NO_COLOR environment variable when"
    echo "                    calling this script)"
    echo "  --force-color     Force the use of colored output"
    echo "                    (overrides the NO_COLOR environment variable)"
    echo "                    calling this script)"
    exit 0
}

TEMP=$(getopt --options 'hi:l:' \
    --longoptions 'help,inventory:limit:' -- "$@")
eval set -- "${TEMP}"

inventory="${INVENTORY}"
limit=
show_help=0
while true ; do
    case "$1" in
        -h|--help) show_help=1; shift ;;

        -i|--inventory) inventory=$2; shift; shift ;;
        -l|--limit) limit=$2; shift; shift ;;

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

declare -a arg_list
[[ -n "${limit}" ]] && arg_list+=("--limit=${limit}")

ansible-playbook qemu-agent.yaml \
    --inventory="${inventory}" \
    "${arg_list[@]}"
