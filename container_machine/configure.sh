#!/bin/bash

help() {
    echo "usage: $(basename $0) [options] [item]"
    echo
    echo "Configure a machine to run containers"
    echo
    echo "options:"
    echo "  -h | --help     Show this help text"
    echo "  -e | --engine   The engine used to run containers docker (default) or podman"
    echo "  -l | --limit    Limit to a subset of hosts matching a pattern"
}

TEMP=$(getopt --options 'he:l:' --longoptions 'help,engine:,limit:' -- "$@")

if [[ ${#} -eq 0 ]]; then
    help
    exit 1
fi

eval set -- "${TEMP}"

declare -a arglist

ENGINE=
LIMIT=
while true ; do
    case "$1" in
        -h|--help) help; exit 0 ;;
        -e|--engine) ENGINE=$2; shift; shift ;;
        -l|--limit) LIMIT=$2; shift; shift ;;
        *) shift; break ;;
    esac
done

[ ! -z "${ENGINE}" ] && arglist+=("-e container_engine=${ENGINE}")
[ ! -z "${LIMIT}" ] && arglist+=("--limit=${LIMIT}")

ansible-playbook configure.yaml \
    "${arglist[@]}" \
    -i ../inventory \
    -e @../common/vars/secrets.yaml \
    "$@"
