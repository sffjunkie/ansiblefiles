#!/bin/bash
source ../common/script/functions.sh

INVENTORY=../inventory

_version="0.1.0"

help() {
    echo "Configure a vm node"
    echo
    echo -n "usage: "; script; param "node"
    echo
    echo -n "Where "; param "[node]"; echo " is a node name in the 'vm_nodes' group in the inventory"
    echo -n "A node name is required unless the "; param "--all"; echo " option is provided"
    echo
    echo "options:"
    echo "  -a | --all        Configure all hosts in the 'vm_nodes' group"
    echo "  -i | --inventory  Path to the ansible inventory (default ${INVENTORY})"
    echo
    echo "  -h | --help       Show this help text"
    echo "  -V | --version    Show the version number"
    echo "  --no-color        Don't use colored output"
    echo "                    (or set the NO_COLOR environment variable when"
    echo "                    calling this script)"
    echo "  --force-color     Force the use of colored output"
    echo "                    (overrides the NO_COLOR environment variable)"
    echo
    exit 0
}

unknown_node() {
    echo -n "Node "; param "$1"; echo " not recognised."
    exit 1
}

show_help=0
if [[ "$#" -eq 0 ]]; then
    show_help=1
else
    TEMP=$(getopt --options 'hai:l:' --longoptions 'help,all,inventory:,limit:,no-color,force-color' -- "$@")
    eval set -- "${TEMP}"

    inventory="${INVENTORY}"
    while true ; do
        case "$1" in
            -i|--inventory) inventory=$2; shift; shift ;;

            -h|--help) show_help=1; shift ;;
            -V|--version) script; echo " version ${_version}" ; exit 0 ;;
            --no-color) NO_COLOR=1; shift ;;
            --force-color) FORCE_COLOR=1; shift ;;
            *) shift; break ;;
        esac
    done
fi

COLOR=1
[[ ! -t 1 ]] && COLOR=0
[[ ${TERM} == "dumb" ]] && COLOR=0
[[ -n ${NO_COLOR} ]] && COLOR=0
[[ -n ${FORCE_COLOR} ]] && COLOR=1

[[ $# -eq 0 || ${show_help} -eq 1 ]] && help

node=$1
shift

[[ -z $node ]] && error "node parameter missing" && help

nodeinfo=$(ansible-inventory -i ../inventory --host "$node" 2>/dev/null)
[[ $? -ne 0 ]] && unknown_node "$node"

node_type=$(echo "${nodeinfo}" | jq --raw-output .type)
host_type=${node_type:-proxmox}_vm_node

ansible-playbook "${host_type}.yaml" \
    --inventory="$inventory" \
    --limit="${node}" \
    "$@"
