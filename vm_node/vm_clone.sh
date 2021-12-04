#!/bin/bash

source ../common/script/functions.sh

INVENTORY=../inventory

[ ! -t 1 ] && NO_COLOR=1
[ "$TERM" == "dumb" ] && NO_COLOR=1

_version="0.1.0"

declare -a extra_arg_list
declare -a errors


help() {
    # If not a tty
    [ ! -t 1 ] && exit 1

    echo "Clone an existing VM"
    echo
    echo -n "usage: "
    script
    echo -n " "
    param "node "
    param "source"
    echo
    echo
    echo -n "Where "
    param "node"
    echo " is the name of the node defined in the inventory and"
    param "source"
    echo " is the virtual machine id or name to clone"
    echo
    echo "options:"
    echo "  -h | --help       Show this help text"
    echo "  -i | --inventory  Path to the ansible inventory (default ${INVENTORY})"
    echo "                    (or set the INVENTORY environment variable when"
    echo "                    calling this script)"
    echo "  -n | --name       Target virtual machine name"
    echo "  -t | --target     Target virtual machine id"
    echo "  -s | --start      If provided then the VM will be started"
    echo
    echo "  -V | --version    Display version information"
    echo "  --no-color        Don't use colored output"
    echo "                    (or set the NO_COLOR environment variable when"
    echo "                    calling this script)"
    echo
    exit 0
}

unknown_node() {
    errors+=("Node $1 not recognised.")
}

not_number() {
    errors+=("$1 needs to be a number.")
}

clone_info() {
    # If not a tty
    [ ! -t 1 ] && return

    echo -n "Cloning virtual machine id "
    param "$source"
    echo -n " on node "
    param "$node"

    node_ip=$(echo "${nodeinfo}" | jq --raw-output .ansible_host)
    [ -z "${target}" ] && [ -z "${name}" ] && echo " ($node_ip)"
    [ -n "${target}" ] || [ -n "${name}" ] && echo -n " ($node_ip)"

    [ -n "${target}" ] || [ -n "${name}" ] && echo -n " with"
    [ -n "${target}" ] && echo -n " target id "; param "$target"
    [ -n "${name}" ] && echo -n " target name "; param "$name"
    [ -n "${target}" ] || [ -n "${name}" ] && echo
}

TEMP=$(getopt --options 'hi:n:t:sV' --longoptions 'help,inventory:,name:,target:,start,version,no-color' -- "$@")
eval set -- "${TEMP}"

inventory="${INVENTORY}"
name=
target=
while true ; do
    case "$1" in
        -h|--help) show_help=1; shift ;;
        -i|--inventory) inventory=$2; shift; shift ;;
        -n|--name) name=$2; shift; shift ;;
        -t|--target) target=$2; shift; shift ;;
        -V|--version) echo "build.sh version ${_version}" ; exit 0 ;;
        --no-color) NO_COLOR=1; shift ;;
        *) shift; break ;;
    esac
done

[[ $show_help -eq 1 ]] && help

node=$1
shift
source=$1
shift

[ -z "$node" ] || [ -z "$source" ] && errors+=("Both node and source must be provided")

nodeinfo=$(ansible-inventory --inventory="${inventory}" --host "${node}" 2>/dev/null)
[[ $? -ne 0 ]] && unknown_node "$node"

number_re='^[0-9]+$'
[ -n "${target}" ] && [[ ! ${target} =~ $number_re ]] && not_number "target" "${target}"

if [ -t 1 ] && [[ ${#errors[@]} -gt 0 ]] ; then
    for i in "${errors[@]}"
    do
        error "$i"
    done
    exit 1
fi

node_type=$(echo "${nodeinfo}" | jq --raw-output .type)
playbook="${node_type:-proxmox}_vm_clone.yaml"

[ -n "${target}" ] && extra_arg_list+=("-e target_vmid=\"${target}\"")
[ -n "${name}" ] && extra_arg_list+=("-e target_name=${name}")

clone_info

exit 0

ansible-playbook "${playbook}" \
    --inventory="${inventory}" \
    --limit="$node" \
    -e source="$source" \
    "${extra_arg_list[@]}" \
    "$@"
