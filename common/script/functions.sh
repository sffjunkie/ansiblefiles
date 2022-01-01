#!/bin/bash


script() {
    _script=$(basename "$0")
    _error=$1
    [[ ${COLOR} == 1 && ${_error} != 1 ]] && tput setaf 2
    [[ ${COLOR} == 1 && ${_error} == 1 ]] && tput setaf 1
    echo -n "${_script} "
    [[ ${COLOR} == 1 ]] && tput sgr0
}


error() {
    [[ ${COLOR} == 1 ]] && tput setaf 1
    echo -n "$(script 1)" 1>&2
    [[ ${COLOR} == 1 ]] && tput setaf 1
    echo -n "error:" 1>&2
    [[ ${COLOR} == 1 ]] && tput sgr0
    echo " $1" 1>&2
}


warning() {
    [[ ${COLOR} == 1 ]] && tput setaf 3
    echo -n "warning:" 1>&2
    [[ ${COLOR} == 1 ]] && tput sgr0
    echo " $1" 1>&2
}


info() {
    [ "$VERBOSE" -lt "${2:-1}" ] && return
    [[ ${COLOR} == 1 ]] && tput setaf 6
    echo -n "info:" 1>&2
    [[ ${COLOR} == 1 ]] && tput sgr0
    echo " $1" 1>&2
}


param(){
    [[ ${COLOR} == 1 ]] && tput setaf 6
    echo -n "$1"
    [[ ${COLOR} == 1 ]] && tput sgr0
}
