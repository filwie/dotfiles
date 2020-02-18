#!/usr/bin/env bash
set -eu

BOLD="$(tput bold)"
RESET="$(tput sgr0)"

function sep () {
    printf "\n\n"
    eval "printf '=%.0s' {1..$(tput cols)}"
    printf "\n\n"
}

function cprintf () {
    [ $# -lt 2 ] && return
    tput setaf "${1}"; shift
    echo -ne "${@}"
    tput sgr0
}

function info () { cprintf 2 "${@}"; }

function warning () { cprintf 3 "${@}"; }

function error () { cprintf 1 "${@}"; }

function cmd () { info "[$(date +'%T')] ${*}\n"; eval "${@}"; }

function join () {
    separator="${1:?single character separator}"
    shift
    (IFS=${separator}; echo "${*}")
}

function clone_repo() {
    clone_url="${1:?clone URL}"
    clone_dest="${2:?clone destination}"
    if [ -d "$clone_dest" ]; then
        warning "$clone_dest already exists. Skipping..."
    else
        cmd git clone "$pyenv_clone_url" "$clone_dest"
    fi
}

function max_length () {
    local len=-1
    for el in "${@}"; do [[ ${#el} -gt ${len} ]] && len=${#el}; done
    printf "%s" "${len}"
}

function display_as_table () {
    local assoc_arr left_col_width right_col_width pad_char pad_key pad_val
    typeset -n assoc_arr=$1
    left_col_width=$(( 1 + $(max_length "${!assoc_arr[@]}") ))
    right_col_width=$(( 1 + $(max_length "${assoc_arr[@]}") ))
    for key in "${!assoc_arr[@]}"; do
        pad_char=' '
        pad_key=$(( left_col_width - ${#key} ))
        pad_val=$(( right_col_width - ${#assoc_arr[${key}]}))
        printf "| %s%${pad_key}s| %s%${pad_val}s|\n" "${key}" "${pad_char}" "${assoc_arr[${key}]}" "${pad_char}"
    done
}
