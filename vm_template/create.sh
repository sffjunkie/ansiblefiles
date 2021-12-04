#!/bin/bash

source ../common/script/functions.sh

INVENTORY=../inventory

[ ! -t 1 ] && NO_COLOR=1
[ "$TERM" == "dumb" ] && NO_COLOR=1

_version="0.1.0"

declare -a extra_arg_list
declare -a errors
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
    echo "  -r | --release    Release version to download (default: latest)"
    echo
    echo "  -V | --version    Display version information"
    echo "  --no-color        Don't use colored output"
    echo "                    (or set the NO_COLOR environment variable when"
    echo "                    calling this script)"
    echo
    exit 0
}


build_info() {
    # If not a tty
    [ ! -t 1 ] && return

    echo -n "Creating virtual machine template "
    echo
}


TEMP=$(getopt --options 'hi:n:t:sV' --longoptions 'help,inventory:,name:,target:,start,version,no-color' -- "$@")
eval set -- "${TEMP}"

inventory="${INVENTORY}"
name=
while true ; do
    case "$1" in
        -h|--help) show_help=1; shift ;;
        -i|--inventory) inventory=$2; shift; shift ;;
        -o|--output) output=$2; shift; shift ;;
        -V|--version) echo "${_script} version ${_version}" ; exit 0 ;;
        --no-color) NO_COLOR=1; shift ;;
        *) shift; break ;;
    esac
done

[[ $show_help -eq 1 ]] && help

os="$1"
shift
name="$1"
shift

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

exit 0

ansible-playbook create_template.yaml \
    --inventory="${inventory}" \
    "${extra_arg_list[@]}" \
    "$@"
