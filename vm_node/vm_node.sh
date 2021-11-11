#!/bin/bash

help() {
    echo "Configure a vm node"
    echo
    echo "usage: $(basename $0) node_name"
    echo
    echo "options:"
    echo "  -h | --help     Show this help text"
    echo
}

unknown_node() {
    echo "Node $1 not recognised."
    exit 1
}

TEMP=$(getopt --options 'h' --longoptions 'help' -- "$@")
eval set -- "${TEMP}"

while true ; do
    case "$1" in
        -h|--help) help; exit 0 ;;
        *) shift; break ;;
    esac
done

node=$1
shift

[[ -z $node ]] && help && exit 0

nodeinfo=$(ansible-inventory -i ../inventory --host $node 2>/dev/null)
[[ $? -ne 0 ]] && unknown_node $node
node_type=$(echo ${nodeinfo} | jq --raw-output .type)
host_type=${host_type:-proxmox}

ansible-playbook -i ../inventory --limit ${node} "${host_type}.yaml" \
    -e @./vars/secrets.yaml "$@"
    # --ask-vault-pass
