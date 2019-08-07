#!/usr/bin/env bash
set -eu

function _log () {
    # $1 - message
    # [$2] - level (defaults to info)
    [[ -n "${1}" ]] || return
    local msg level
    declare -A color_map
    color_map=(["debug"]=4 ["info"]=2 ["warning"]=3 ["error"]=1 ["running"]=6)
    msg="${1}"; level="${2:-info}"

    [[ "${level}" =~ ^(debug|info|warning|error|running)$ ]] || level="info"

    color="${color_map[${level}]}"
    echo -ne "$(tput setaf "${color}")$(date +%T) ${BASH_LINENO[0]} ${level}:\t${msg}$(tput sgr0)"
}

function run_log () {
    # $1 - command to run
    [[ -n "${1}" ]] || return
    _log "${1}\n" running
    eval "${1}"
}

function join () {
    # $1 - separator (single character)
    # $2 - array to join
    # Example:
    #     join ',' "${array[@]}"
    separator="${1}"; shift
    (IFS=${separator}; echo "${*}")
}

