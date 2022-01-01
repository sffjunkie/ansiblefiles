#!/bin/bash

source ../common/script/functions.sh

help() {
    echo "Preconfigure a machine"
    echo
    echo -n "usage: "; script;
    echo -n " ["; param "options"; echo -n "] ["; param "item"; echo -n "]"
    echo
    echo "options:"
    echo "  -h | --help     Show this help text"
    echo "  -l | --limit    Limit to a subset of hosts matching a pattern"
}

TEMP=$(getopt --options 'hl:' --longoptions 'help,limit:' -- "$@")

if [[ ${#} -eq 0 ]]; then
    help
    exit 1
fi

eval set -- "${TEMP}"

declare -a arg_list

LIMIT=
while true ; do
    case "$1" in
        -h|--help) help; exit 0 ;;
        -l|--limit) LIMIT=$2; shift; shift ;;
        *) shift; break ;;
    esac
done

[ -n "${LIMIT}" ] && arg_list+=("--limit=${LIMIT}")

ansible-playbook configure.yaml \
    -i ../inventory \
    -e configfiles_path="$(realpath ../configbuild)" \
    -e scriptfiles_path="$(realpath ../scriptfiles)" \
    "${arg_list[@]}" \
    "$@"

    # -e @../common/vars/secrets.yaml \
