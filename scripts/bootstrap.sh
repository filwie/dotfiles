#!/usr/bin/env bash
set -eu
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

source "$SCRIPT_DIR/lib.sh"
# source "$SCRIPT_DIR/bootstrap/"* || true

XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

declare -A CLONE_MAP=(
    ["https://github.com/pyenv/pyenv.git"]="$XDG_DATA_HOME/pyenv"
    ["https://github.com/junegunn/fzf.git"]="${FZF_BASE:-$XDG_DATA_HOME/fzf}"
    ["https://github.com/tmux-plugins/tpm "]="${TMUX_PLUGIN_MANAGER_PATH:-$XDG_DATA_HOME/tmux/plugins/tpm}"
)

lib.sep
lib.display_as_table CLONE_MAP
lib.sep
for url in "${!CLONE_MAP[@]}"; do
    dest="${CLONE_MAP[$url]}"
    lib.clone_repo "$url" "$dest"
done
