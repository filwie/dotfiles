#!/usr/bin/env bash
set -eu

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"${HOME}/.config"}"
XDG_DATA_HOME="${XDG_DATA_HOME:-"${HOME}/.local/share"}"

REPO_ROOT="$(cd "$(dirname "$(realpath "${0}")")" || exit; git rev-parse --show-toplevel)"
source "$REPO_ROOT/scripts/lib.sh"

declare -A LINK_MAP=(
    ["${REPO_ROOT}/home/.local/bin/*"]="${HOME}/.local/bin/"
    ["${REPO_ROOT}/home/.config/*"]="${HOME}/.local/config/"
)

lib.display_as_table LINK_MAP
lib.border_lower
