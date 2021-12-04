#!/bin/bash

source ../common/script/functions.sh

INVENTORY=../inventory

[ ! -t 1 ] && NO_COLOR=1
[ "$TERM" == "dumb" ] && NO_COLOR=1

_version="0.1.0"

help() {
    echo "usage: $(basename $0) [options]"
    echo
    echo "Install the qemu agent on a machine"
    echo
    echo "options:"
    echo "  -h | --help     Show this help text"
    echo "  -i | --inventory  Path to the ansible inventory (default ${INVENTORY})"
    echo "                    (or set the INVENTORY environment variable when"
    echo "                    calling this script)"
    echo "  -l | --limit    Limit to a subset of hosts matching a pattern"
}

TEMP=$(getopt --options 'hi:l:' --longoptions 'help,inventory:limit:' -- "$@")

if [[ ${#} -eq 0 ]]; then
    help
    exit 1
fi

eval set -- "${TEMP}"

declare -a arglist

inventory="${INVENTORY}"
limit=
while true ; do
    case "$1" in
        -h|--help) help; exit 0 ;;
        -i|--inventory) inventory=$2; shift; shift ;;
        -l|--limit) limit=$2; shift; shift ;;
        *) shift; break ;;
    esac
done

[ -n "${limit}" ] && arglist+=("--limit=${limit}")

ansible-playbook qemu-agent.yaml \
    --inventory="${inventory}" \
    "${arglist[@]}"
