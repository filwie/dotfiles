#!/usr/bin/env bash

declare -A CALIBRE_LIBRARY=(
    [remote_name]="Google Drive"
    [remote_path]="Calibre Library/"
    [local_path]="${HOME}/Documents/Calibre Library/"

)

declare -A GOOGLE_PHOTOS=(
    [remote_name]="Google Photos"
    [remote_path]="media/all/"
    [local_path]="${HOME}/Pictures/Google Photos/"
)

bold="$(tput bold)"
reset="$(tput sgr0)"

function cmd () {
    printf "\nRUNNING: %s%s%s\n" "${bold}" "${*}" "${reset}"
    eval "${*}"
}

function sync () {
    local arg src dest
    typeset -n arg=${1}; shift

    src="${arg[remote_name]}:${arg[remote_path]}"
    dest="${arg[local_path]}"

    cmd rclone sync "'${src}'" "'${dest}'" "${@}"
}

sync CALIBRE_LIBRARY &
sync GOOGLE_PHOTOS --include '*.jpg' --include '*.JPG' &

wait
