#!/bin/bash

source ../common/script/functions.sh

help() {
    echo "Post-configuration for a machine"
    echo
    echo -n "usage: "; script; echo
    echo
    echo "options:"
    echo "  -h | --help     Show this help text"
    echo "  -l | --limit    Limit to a subset of hosts matching a pattern"
}

TEMP=$(getopt --options 'hl:v' --longoptions 'help,limit:,verbose' -- "$@")

if [[ ${#} -eq 0 ]]; then
    help
    exit 1
fi

eval set -- "${TEMP}"

declare -a arg_list

limit=
while true ; do
    case "$1" in
        -h|--help) help; exit 0 ;;
        -l|--limit) limit=$2; shift; shift ;;
        *) shift; break ;;
    esac
done

[ -n "${limit}" ] && arg_list+=("--limit=${limit}")

ansible-playbook postconfigure.yaml \
    -i ../inventory \
    "${arg_list[@]}" \
    "$@"
    # -e @../common/vars/secrets.yaml
