#!/bin/bash

source ../common/script/functions.sh

INVENTORY=../inventory

[ ! -t 1 ] && NO_COLOR=1
[ "$TERM" == "dumb" ] && NO_COLOR=1

_version="0.1.0"

help() {
    echo "Configure a vm node"
    echo
    echo -n "usage: "; script; param "node"
    echo
    echo -n "Where "; param "node"; echo " is the name of the node defined in the inventory"
    echo
    echo "options:"
    echo "  -h | --help       Show this help text"
    echo "  -i | --inventory  Path to the ansible inventory (default ${INVENTORY})"
    echo "  -l | --limit      Limit to a subset of hosts matching a pattern"
    echo
    exit 0
}

unknown_node() {
    echo "Node $1 not recognised."
    exit 1
}

TEMP=$(getopt --options 'hi:l:' --longoptions 'help,inventory:,limit:' -- "$@")
eval set -- "${TEMP}"

inventory="${INVENTORY}"
while true ; do
    case "$1" in
        -h|--help) help ;;
        -i|--inventory) inventory=$2; shift; shift ;;
        *) shift; break ;;
    esac
done

node=$1
shift

[[ -z $node ]] && help

nodeinfo=$(ansible-inventory -i ../inventory --host "$node" 2>/dev/null)
[[ $? -ne 0 ]] && unknown_node "$node"

node_type=$(echo "${nodeinfo}" | jq --raw-output .type)
host_type=${node_type:-proxmox}_vm_node

ansible-playbook "${host_type}.yaml" \
    --inventory="$inventory" \
    --limit="${node}" \
    "$@"
