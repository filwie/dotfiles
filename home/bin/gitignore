#!/usr/bin/env bash
set -e

function _err () {
    printf "%s%s%s\n" "$(tput setaf 1)" "$*" "$(tput sgr0)"
    return 1
}

function usage () {
    printf "%s\n" "USAGE: gitignore [-h/--help] [-f/--file FILE] [-g/--git] {LANGUAGE/OS/EDITOR}"
    printf "%s\n" "  -h/--help    display help"
    printf "%s\n" "  -f/--file    output to specified FILE"
    printf "%s\n" "  -g/--git     output to .gitignore file in git repository root"
    printf "%s\n" "EXAMPLE: gitignore -g python vim"
    exit 1
}

function main () {
    [[ "$#" -lt 1 ]] && usage

    local output=/dev/stdout

    case "${1}" in
        -h|--help) usage ;;
        -f|--file)
            output="${2}"; shift 2
            ;;
        -g|--git)
            [[ "$(git rev-parse --is-inside-work-tree)" == true ]] || _err "Not in git repo."
            output="$(realpath "$(git rev-parse --show-toplevel)/.gitignore")"; shift
            ;;
    esac
    [[ "$#" -lt 1 ]] && usage

    for lang in "${@}"; do
        curl -sL "https://www.gitignore.io/api/${lang}" | tee -a "${output}"
    done
}

main "${@}"
