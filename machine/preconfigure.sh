#!/bin/bash

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
    echo "  -l | --limit      Limit to a subset of hosts matching a pattern"
    echo "  -u | --users      File containing additional users to create"
    echo "  -V | --version    Display version information"
    echo "  --no-color        Don't use colored output"
    echo "                    (or set the NO_COLOR environment variable when"
    echo "                    calling this script)"
}

TEMP=$(getopt --options 'hl:v' --longoptions 'help,limit:,verbose' -- "$@")

if [[ ${#} -eq 0 ]]; then
    help
    exit 1
fi

eval set -- "${TEMP}"

declare -a arglist

limit=
user_file=
verbose=0
while true ; do
    case "$1" in
        -h|--help) help; exit 0 ;;
        -l|--limit) limit=$2; shift; shift ;;
        -u|--user-file) user_file=$2; shift; shift ;;
        -v|--verbose) verbose=( "$verbose" + 1 ); shift ;;
        -V|--version) echo "${_script} version ${_version}" ; exit 0 ;;
        --no-color) NO_COLOR=1; shift ;;
        *) shift; break ;;
    esac
done

[ -n "${limit}" ] && arglist+=("--limit=${limit}")
[ -n "${user_file}" ] && arglist+=("-e user_file=${user_file}")

ansible-playbook preconfigure.yaml \
    -i ../inventory \
    "${arglist[@]}" \
    "$@"
