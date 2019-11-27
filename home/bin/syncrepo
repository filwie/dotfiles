#!/usr/bin/env bash
set -eu

REPO="$(realpath "$(git rev-parse --show-toplevel)")"
GITIGNORE="${REPO}/.gitignore"

_sync_destination_help="set this variable first. Example value: user@host:~/dest"
DEST="${DEST:?${_sync_destination_help}}"

BOLD="$(tput bold)"
RESET="$(tput sgr0)"

function _cmd () {
    echo -e "${BOLD}RUNNING:${RESET}\t${*}"
    eval "${@}"
}

function single_sync () {
    _cmd rsync -avz "${REPO}" --filter="':- ${GITIGNORE}'" "${DEST}"
}


function continous_sync () {
    while command inotifywait -r -e modify,attrib,close_write,move,create,delete "${REPO}"; do
        single_sync
    done
}

function main () {
    single_sync
    continous_sync
}

main
