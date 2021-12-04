#!/bin/bash

source ../common/script/functions.sh

INVENTORY=../inventory

[ ! -t 1 ] && NO_COLOR=1
[ "$TERM" == "dumb" ] && NO_COLOR=1

_version="0.1.0"

help() {
    echo "Configure a machine to run containers"
    echo
    echo -n "usage: "; script; echo " [options] [item]"
    echo
    echo "options:"
    echo "  -h | --help     Show this help text"
    echo "  -u | --users    User id's to add to the docker group"
    echo "  -e | --engine   The engine used to run containers"
    echo "                  either docker (default) or podman"
    echo "  -l | --limit    Limit to a subset of hosts matching a pattern"
}

TEMP=$(getopt --options 'he:l:u:' --longoptions 'help,engine:,limit:,users:' -- "$@")

if [[ ${#} -eq 0 ]]; then
    help
    exit 1
fi

eval set -- "${TEMP}"

declare -a arglist

engine=
limit=
users=
inventory="${INVENTORY}"
while true ; do
    case "$1" in
        -h|--help) help; exit 0 ;;
        -i|--inventory) inventory=$2; shift; shift ;;
        -e|--engine) engine=$2; shift; shift ;;
        -l|--limit) limit=$2; shift; shift ;;
        -u|--users) users=$2; shift; shift ;;
        *) shift; break ;;
    esac
done

[ -n "${engine}" ] && arglist+=("-e container_engine=${engine}")
[ -n "${limit}" ] && arglist+=("--limit=${limit}")
[ -n "${users}" ] && arglist+=("-e docker_users=${users}")

ansible-playbook configure.yaml \
    --inventory="$inventory" \
    "${arglist[@]}" \
    "$@"
