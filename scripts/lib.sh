#!/usr/bin/env bash
set -eu

BOLD="$(tput bold)"
RESET="$(tput sgr0)"

function lib.sep () {
    eval "printf '=%.0s' {1..$(tput cols)}"
}

function lib.cprintf () {
    [ $# -lt 2 ] && return
    tput setaf "${1}"; shift
    echo -ne "${@}"
    tput sgr0
}

function lib.info () { lib.cprintf 2 "${@}"; }

function lib.warning () { lib.cprintf 3 "${@}"; }

function lib.error () { lib.cprintf 1 "${@}"; }

function lib.cmd () { lib.info "[$(date +'%T')] ${*}\n"; eval "${@}"; }

function lib.join () {
    separator="${1:?single character separator}"
    shift
    (IFS=${separator}; echo "${*}")
}

function lib.clone_repo() {
    clone_url="${1:?clone URL}"
    clone_dest="${2:?clone destination}"
    if [ -d "$clone_dest" ]; then
        lib.warning "$clone_dest already exists. Skipping...\n"
    else
        lib.cmd git clone "$clone_url" "$clone_dest"
    fi
}

function lib.max_length () {
    local len=-1
    for el in "${@}"; do [[ ${#el} -gt ${len} ]] && len=${#el}; done
    printf "%s" "${len}"
}

function lib.display_as_table () {
    local assoc_arr left_col_width right_col_width pad_char pad_key pad_val
    typeset -n assoc_arr=$1
    left_col_width=$(( $(tput cols) / 2 - 2))
    right_col_width="$left_col_width"
    for key in "${!assoc_arr[@]}"; do
        pad_char=' '
        pad_key=$(( left_col_width - ${#key} ))
        pad_val=$(( right_col_width - ${#assoc_arr[${key}]}))
        printf "| %s%${pad_key}s| %s%${pad_val}s|\n" "${key}" "${pad_char}" "${assoc_arr[${key}]}" "${pad_char}"
    done
}
