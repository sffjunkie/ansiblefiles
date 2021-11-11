#!/bin/bash

help() {
    echo "Cloud-init configuration / nocloud data-source image creator"
    echo
    echo "usage: $(basename $0) [task]"
    echo
    echo " Where task is one of config, image or copy"
    echo
    echo "  config - Generates YAML user and meta config files"
    echo "  image - Generates the configs and a nocloud image"
    echo "  copy - Copies the generated configs and images to the host"
    echo
    echo " If no task is specified then all tasks will run"
    echo
    echo "options:"
    echo "  -h | --help     Show this help text"
    echo "  -n | --name     Name used for output config and image file names"
    echo
}

TEMP=$(getopt --options 'hn:' --longoptions 'help,name' -- "$@")
eval set -- "${TEMP}"

NAME=""
while true ; do
    case "$1" in
        -h|--help) help; exit 0 ;;
        -n|--name) NAME=$2; shift; shift ;;
        *) shift; break ;;
    esac
done

stage=$1
shift

case "$stage" in
    config)
        ansible-playbook configure.yaml -i ../inventory \
        -e cli_config_name=$NAME \
        --skip-tags=image,copy "$@"
        ;;

    image)
        ansible-playbook configure.yaml -i ../inventory \
        -e cli_config_name=$NAME \
        --skip-tags=copy "$@"
        ;;

    copy)
        ansible-playbook configure.yaml -i ../inventory \
        -e cli_config_name=$NAME \
        --skip-tags=config,image "$@"
        ;;

    *)
        ansible-playbook configure.yaml -i ../inventory \
        -e cli_config_name=$NAME \
        "$@"
        ;;
esac
