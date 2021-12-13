#!/bin/bash

INVENTORY=../inventory
SECRETS=./vars/secrets.yaml

source ../common/script/functions.sh

[ ! -t 1 ] && NO_COLOR=1
[ "$TERM" == "dumb" ] && NO_COLOR=1

_version="0.1.0"

help() {
    echo "Preconfigure a machine"
    echo
    echo -n "usage: "; script; echo
    echo
    echo "options:"
    echo "  -h | --help       Show this help text"
    echo "  -i | --inventory  Path to the ansible inventory (default ${INVENTORY})"
    echo "                    (or set the INVENTORY environment variable when"
    echo "                    calling this script)"
    echo "  -l | --limit      Limit to a subset of hosts matching a pattern"
    echo "  -s | --secrets    File to load secrets from (default ${SECRETS})"
    echo "  -u | --users      File containing additional users to create"
    echo "  -V | --version    Display version information"
    echo "  --no-color        Don't use colored output"
    echo "                    (or set the NO_COLOR environment variable when"
    echo "                    calling this script)"
}

TEMP=$(getopt --options 'hi:l:s:u:v' --longoptions 'help,inventory:,limit:,secrets:,users:,verbose' -- "$@")

if [[ ${#} -eq 0 ]]; then
    help
    exit 1
fi

eval set -- "${TEMP}"

declare -a arglist

limit=
user_file=
verbose=0
inventory="${INVENTORY}"
secrets="${SECRETS}"
while true ; do
    case "$1" in
        -h|--help) help; exit 0 ;;
        -i|--inventory) inventory=$2; shift; shift ;;
        -l|--limit) limit=$2; shift; shift ;;
        -s|--secrets) secrets=$2; shift; shift ;;
        -u|--user-file) user_file=$2; shift; shift ;;
        -v|--verbose) verbose=( "$verbose" + 1 ); shift ;;
        -V|--version) echo "${_script} version ${_version}" ; exit 0 ;;
        --no-color) NO_COLOR=1; shift ;;
        *) shift; break ;;
    esac
done

[ -n "${limit}" ] && arglist+=("--limit=${limit}")
[ -n "${user_file}" ] && arglist+=("-e users_file=${user_file}")

ansible-playbook preconfigure.yaml \
    --inventory "${inventory}" \
    -e "@${secrets}" \
    "${arglist[@]}" \
    "$@"
