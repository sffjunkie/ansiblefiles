#!/bin/bash
source ../common/script/functions.sh

INVENTORY=../inventory

_version="0.1.0"

os_names=( debian fedora ubuntu )

help() {
    # If not a tty
    [ ! -t 1 ] && exit 1

    echo "Create a VM template"
    echo
    echo -n "usage: "
    script; param "os "; param "name"
    echo
    echo "Where:"
    echo -n "  "; param "os"; echo " = the os image type and is one of"
    for i in "${os_names[@]}"
    do
        echo "    * $i"
    done
    echo -n "  "; param "name"; echo " = name of the output image file"
    echo
    echo "options:"
    echo "  -h | --help       Show this help text"
    echo
    echo "  -r | --release    Release version to download (default: latest)"
    echo
    echo "  -V | --version    Display version information"
    echo "  --no-color        Don't use colored output"
    echo "                    (or set the NO_COLOR environment variable when"
    echo "                    calling this script)"
    echo "  --force-color     Force the use of colored output"
    echo "                    (overrides the NO_COLOR environment variable)"
    echo
    exit 0
}

build_info() {
    # If not a tty
    [ ! -t 1 ] && return

    echo -n "Creating virtual machine template "
    echo
}

TEMP=$(getopt --options 'hi:n:t:sV' \
    --longoptions 'help,inventory:,name:,target:,start,version,no-color,force-color' -- "$@")
eval set -- "${TEMP}"

inventory="${INVENTORY}"
name=
while true ; do
    case "$1" in
        -h|--help) show_help=1; shift ;;

        -i|--inventory) inventory=$2; shift; shift ;;

        -V|--version) script; echo " version ${_version}" ; exit 0 ;;
        --no-color) NO_COLOR=0; shift ;;
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

os="$1"
shift
name="$1"
shift

declare -a errors
_names=$(printf '%s' "${os_names[0]}"; printf ', %s' "${os_names[@]:1}")
[[ ! "${os_names[*]}" =~ \s*${os}\s* ]] && errors+=("Invalid os ${os}. Must be one of; ${_names}")

if [ -t 1 ] && [[ ${#errors[@]} -gt 0 ]] ; then
    for i in "${errors[@]}"
    do
        error "$i"
    done
    exit 1
fi

build_info

ansible-playbook create_template.yaml \
    --inventory="${inventory}" \
    "$@"
