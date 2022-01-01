#!/bin/bash
source ../common/script/functions.sh

INVENTORY=../inventory

_version="0.1.0"

help() {
    echo "Configure a machine to run containers"
    echo
    echo -n "usage: "; script; param "[options]"
    echo
    echo "options:"
    echo "  -h | --help       Show this help text"
    echo
    echo "  -e | --engine     The engine used to run containers"
    echo "                    either docker (default) or podman"
    echo "  -c | --compose    If set then use docker compose (default is false)"
    echo "  -i | --inventory  Path to the ansible inventory (default ${INVENTORY})"
    echo "                    (or set the INVENTORY environment variable when"
    echo "                    calling this script)"
    echo "  -l | --limit      Limit to a subset of hosts matching a pattern"
    echo "  -u | --users      Users to add to the docker/podman group"
    echo
    echo "  -V | --version    Display version information"
    echo "  --no-color        Don't use colored output"
    echo "                    (or set the NO_COLOR environment variable when"
    echo "                    calling this script)"
    echo "  --force-color     Force the use of colored output"
    echo "                    (overrides the NO_COLOR environment variable and"
    echo "                    --no-color option)"
    exit 0
}

TEMP=$(getopt --options 'i:ce:l:u:hV' \
    --longoptions 'inventory,engine:,compose,limit:,users:,help,no-color,force-color,version' -- "$@")
eval set -- "${TEMP}"

engine=
docker_compose="false"
limit=
users=
inventory="${INVENTORY}"
show_help=0
while true ; do
    case "$1" in
        -h|--help) show_help=1; shift ;;

        -e|--engine) engine=$2; shift; shift ;;
        -c|--compose) docker_compose="true"; shift ;;
        -i|--inventory) inventory=$2; shift; shift ;;
        -l|--limit) limit=$2; shift; shift ;;
        -u|--users) users=$2; shift; shift ;;

        -V|--version) echo "${_version}" ; exit 0 ;;
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

declare -a arg_list
[[ -n "${engine}" ]] && arg_list+=("-e container_engine=${engine}")
[[ -n "${limit}" ]] && arg_list+=("--limit=${limit}")
[[ -n "${users}" ]] && arg_list+=("-e container_users=${users}")
arg_list+=("-e use_compose=${docker_compose}")

ansible-playbook configure.yaml \
    --inventory="$inventory" \
    "${arg_list[@]}" \
    "$@"
