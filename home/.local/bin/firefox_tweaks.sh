#!/usr/bin/env bash

# RESOURCE
# https://wiki.archlinux.org/index.php/Firefox/Tweaks

_values_file="${1:-"${HOME}/config/firefox/config.$(hostname)"}"
echo "${_values_file}"

dpi_scale="${dpi_scale:-1.3}"
gpu_accel="${gpu_accel:-true}"

FIREFOX_PROFILE="$(grep 'Path=' ~/.mozilla/firefox/profiles.ini | sed s/^Path=// | egrep 'default$')"
CONFIG_FILE="${HOME}/.mozilla/firefox/${FIREFOX_PROFILE}/user.js"

declare -A SETTINGS=(
    [layers.acceleration.force-enabled]="${gpu_accel}"
    [layout.css.devPixelsPerPx]="${dpi_scale}"
)

_green="$(tput setaf 2)"
_yellow="$(tput setaf 3)"
_bold="$(tput bold)"
_reset="$(tput sgr0)"


function add_line () {
    local line config
    line="${1:?setting line to add to config}"
    config="${2:?config file path}"

    if grep -q "${line}" "${config}"; then
        echo "${_green}Line${_bold} already present.${_reset}"
    elif ! grep -q "${line%,*}" "${config}"; then
        printf "${line}\n" >> "${config}"
        echo "${_yellow}Line${_bold} appended.${_reset}"
    else
        sed -i "s/^${line%,*}.*$/${line}/" "${config}"
        echo "${_yellow}Value${_bold} changed.${_reset}"
    fi
}

function tweak_firefox () {
    [[ -f ${CONFIG_FILE} ]] || touch "${CONFIG_FILE}"

    for key in "${!SETTINGS[@]}"; do
        value="${SETTINGS[${key}]}"

        line="user_pref(\"${key}\", ${value});"
        add_line "${line}" "${CONFIG_FILE}"
    done

    if pidof firefox > /dev/null; then
        pidof firefox | xargs kill -SIGCONT
    fi
}

tweak_firefox
