#!/bin/bash
source ../common/script/functions.sh

# INVENTORY="../inventory"

_version="0.1.0"


help() {
    echo "Service file builder"
    echo
    echo "Usage:"
    echo -n "  $ "
    script
    echo
    echo "Options:"
    echo "  -h | --help       Show this help text"
    echo "  -v | --verbose    Display information about the script"
    echo "  -V | --version    Display version information"
    echo "  --no-color        Don't use colored output"
    echo "                    (or set the NO_COLOR environment variable when"
    echo "                    calling this script)"
    echo "  --force-color     Force the use of colored output"
    echo "                    (overrides the NO_COLOR environment variable)"
    exit 0
}

TEMP=$(getopt --options 'hn:di:u:m:vV' \
    --longoptions 'help,no-color,force-color,verbose,version' -- "$@")
eval set -- "${TEMP}"

# inventory="$INVENTORY"
verbose=0
while true ; do
    case "$1" in
        -h|--help) show_help=1; shift ;;
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

ansible-playbook build.yaml \
    --inventory="${inventory}" \
    "$@"
