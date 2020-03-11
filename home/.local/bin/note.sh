#!/usr/bin/env bash

NOTES_DIR="${NOTES_DIR:-"$HOME/.local/share/notes"}"
NOTES_EXT="${NOTES_EXT:-".md"}"
NOTE_FILENAME="${NOTES_DIR}/$(date '+%Y-%m-%d')"
HEADING="## $(date '+%a, %B %d %Y')"

[ -d "$NOTES_DIR" ] ||  mkdir -p "$NOTES_DIR"
# shellcheck disable=SC2048
for word in ${*}; do
    NOTE_FILENAME+="-${word,,}"
done
NOTE_FILENAME+="${NOTES_EXT}"

[ -n "${*}" ] && HEADING+=" - ${*}"

if [ -f "${NOTE_FILENAME}" ]; then
    echo "${HEADING}"
    echo "$(head -n1 "${NOTE_FILENAME}")"
    if [[ "$(head -n1 "${NOTE_FILENAME}")" != "${HEADING}" ]]; then
        sed -i "1s/^/${HEADING}\\n/" "${NOTE_FILENAME}"
    fi
else
    echo "${HEADING}" > "${NOTE_FILENAME}"
fi

vim +'normal o' +'startinsert' "${NOTE_FILENAME}"
