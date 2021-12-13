#!/bin/bash

error() {
    [ -z "${NO_COLOR}" ] && tput setaf 1
    echo -n "Error:" 1>&2
    [ -z "${NO_COLOR}" ] && tput sgr0
    echo " $1" 1>&2
}


warning() {
    [ -z "${NO_COLOR}" ] && tput setaf 3
    echo -n "Warning:" 1>&2
    [ -z "${NO_COLOR}" ] && tput sgr0
    echo " $1" 1>&2
}


info() {
    [ "$VERBOSE" -lt "${2:-1}" ] && return
    [ -z "${NO_COLOR}" ] && tput setaf 6
    echo -n "Info:" 1>&2
    [ -z "${NO_COLOR}" ] && tput sgr0
    echo " $1" 1>&2
}


param(){
    [ -z "${NO_COLOR}" ] && tput setaf 6
    echo -n "$1"
    [ -z "${NO_COLOR}" ] && tput sgr0
}


script() {
    _script=$(basename "$0")
    [ -z "${NO_COLOR}" ] && tput setaf 2
    echo -n "${_script} "
    [ -z "${NO_COLOR}" ] && tput sgr0
}
