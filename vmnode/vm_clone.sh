#!/bin/bash
help() {
    echo "usage: $(basename $0) [options] <from> <name>"
    echo
    echo "Clone a Proxmox vmid <from> as the name <name>"
    echo
    echo "options:"
    echo "  -h | --help     Show this help text"
    echo "  -t | --target   Target vmid. Defaults to the next available id."
    exit 1
}

TEMP=$(getopt --options 'ht:' --longoptions 'help,target:' -- "$@")

if [[ ${#} -eq 0 ]]; then
    help
fi

eval set -- "${TEMP}"

while true; do
    case "$1" in
    -h | --help)
        help
        exit 0
        ;;
    -t | --target)
        TARGET=$2
        shift
        shift
        ;;
    *)
        shift
        break
        ;;
    esac
done

[[ -z "$2" ]] && help

echo -n "Cloning vmid $1 as '$2'"
[[ ! -z "${TARGET}" ]] && echo " with vmid ${TARGET}" || echo ""

# ansible-playbook clone.yaml \
#     -e source_vmid=$1 \
#     -e target_vmid=${TARGET} \
#     -e target_name=$2 \
#     -e @./vars/secrets.yaml "$@" \
#     --ask-vault-pass
