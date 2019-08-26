#!/usr/bin/env bash
# To use, run this script, then click on a window.

# Check for xwininfo and xprop

for cmd in xwininfo xprop; do
    if ! command -v $cmd &> /dev/null; then
        echo "$(basename): ${cmd}: command not found" > /dev/stderr
        exit 1
    fi
done

function get_window_details () {
    local match_int match_string match_qstring
    match_int='[0-9][0-9]*'
    match_string='".*"'
    match_qstring='"[^"\\]*(\\.[^"\\]*)*"' # NOTE: Adds 1 backreference
    {
        # Run xwininfo, get window id
        window_id="$(xwininfo -int | sed -nre "s/^xwininfo: Window id: ($match_int) .*$/\1/p")"
        echo "id=$window_id"

        # Run xprop, transform its output into i3 criteria. Handle fallback to
        # WM_NAME when _NET_WM_NAME isn't set
        xprop -id $window_id |
            sed -nr \
            -e "s/^WM_CLASS\(STRING\) = ($match_qstring), ($match_qstring)$/instance=\1\nclass=\3/p" \
            -e "s/^WM_WINDOW_ROLE\(STRING\) = ($match_qstring)$/window_role=\1/p" \
            -e "/^WM_NAME\(STRING\) = ($match_string)$/{s//title=\1/; h}" \
            -e "/^_NET_WM_NAME\(UTF8_STRING\) = ($match_qstring)$/{s//title=\1/; h}" \
            -e '${g; p}'
    } | sort | tr "\n" " " | sed -r 's/^(.*) $/[\1]\n/'
}

function main () {
    local win_details

    win_details="$(get_window_details)"
    i3-nagbar \
        -t warning \
        -m "Window details: ${win_details}" \
        -b "copy all" "bash -c "notify-send ${win_details}"" \
        --font 'pango:Noto Sans 10'
}

main "${@}"
