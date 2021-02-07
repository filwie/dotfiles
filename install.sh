#!/usr/bin/env bash
set -euo pipefail

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"${HOME}/.config"}"
XDG_BIN_HOME="${XDG_BIN_HOME:-"${HOME}/.local/bin"}"
XDG_DATA_HOME="${XDG_DATA_HOME:-"${HOME}/.local/share"}"

REPO_ROOT="$(cd "$(dirname "$(realpath "${0}")")" || exit; git rev-parse --show-toplevel)"
CONFIGS_DIR="${REPO_ROOT}/home/.config"
SCRIPTS_DIR="${REPO_ROOT}/home/.local/bin"

cd "${CONFIGS_DIR}"
CONFIGS=(*)
cd - > /dev/null
cd "${SCRIPTS_DIR}"
SCRIPTS=(*)
cd - > /dev/null

function list_dotfiles {
    echo "Configs: ${CONFIGS[*]}"
    echo "Scripts: ${SCRIPTS[*]}"
}

function help {
    echo "Usage: ${0} [option] [config|script]"
    echo
    echo "  -l, --list              list available configs and scripts"
    echo "  -a, --all               link all configs and scripts"
    echo "  -c, --configs {CONFIG}  link specified config(s) only"
    echo "  -s, --scripts {SCRIPT}  link specified script(s) only"
    echo "  --all-configs           link all configs"
    echo "  --all-scripts           link all scripts"
    exit
}

function link_one {
    local src dest
    src="$(realpath "${_src_dir:-${CONFIGS_DIR}}/${1:?file or directory in ${CONFIGS_DIR}}")"
    dest="$(realpath "${2:-${_dest:-${XDG_CONFIG_HOME}}}")"

    if ! [ -e "${src}" ]; then
        echo "${src} does not exist"
        return 1
    fi
    printf "${src} -> ${dest}/$(basename ${src}): "
    if [[ "$(ln -s "${src}" "${dest}" 2>&1 >/dev/null)" =~ exists ]]; then
        echo "destination exists. Skipping..."
    else
        echo "linked."
    fi
}

function link_many {
    for src in "${@}"; do
        link_one "${src}"
    done
}

case "${1:---help}" in
    -a|--all)
        link_many "${CONFIGS[@]}"
        _src_dir="${SCRIPTS_DIR}" _dest="${XDG_BIN_HOME}" link_many "${SCRIPTS[@]}"
        ;;
    -l|--list)
        list_dotfiles
        ;;
    -c|--configs)
        shift
        link_many "${@}"
        ;;
    --all-configs)
        link_many "${CONFIGS[@]}"
        ;;
    -s|--scripts)
        shift
        _src_dir="${SCRIPTS_DIR}" _dest="${XDG_BIN_HOME}" link_many "${@}"
        ;;
    --all-scripts)
        _src_dir="${SCRIPTS_DIR}" _dest="${XDG_BIN_HOME}" link_many "${SCRIPTS[@]}"
        ;;
    *)
        help
        ;;
esac

