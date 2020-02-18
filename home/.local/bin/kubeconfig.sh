#!/usr/bin/env bash
set -eu

XDG_DATA_HOME="${XDG_DATA_HOME:-"${HOME}/.local/share"}"
KUBECONFIGS_DIRECTORY="${KUBECONFIGS_DIRECTORY:-"${XDG_DATA_HOME}/kubeconfigs"}"

if ! [ -d "${KUBECONFIGS_DIRECTORY}" ]; then
    mkdir -p "${KUBECONFIGS_DIRECTORY}" \
        && info "\$KUBECONFIGS_DIRECTORY created: ${KUBECONFIGS_DIRECTORY}\n"
fi

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

function usage () {
    echo -e "USAGE: $0 {command} {options}                                            \n"
    echo -e "COMMANDS:                                                                \n"
    echo -e "  fetch {kubectl_name} {scp_remote} - fetches ~/.kube/config from remote \n"
    echo -e "  edit  {kubectl_name}              - opens config in ${EDITOR:-vim}     \n"
    echo -e "  ip    {kubectl_name} {new_ip}:    - changes API address                \n"
    echo -e "  use   {kubectl_name}              - sets specified config as default   \n"
    exit 1
}

fetch () {
    local kubeconfig="${KUBECONFIGS_DIRECTORY}/${1:?user-friendly kubeconfig file name}.yaml"
    local remote="${2:?scp remote ex. user@example.com}"
    cmd scp "${remote}:~/.kube/config" "${kubeconfig}"
}

edit () {
    local kubeconfig="${KUBECONFIGS_DIRECTORY}/${1:?user-friendly kubeconfig file name}.yaml"
    if ! [ -f "${kubeconfig}" ]; then
        error "Kubeconfig ${kubeconfig} does not exist. Fetch it first."
        return 1
    fi
    cmd "${EDITOR:-vim}" "${kubeconfig}"
}

use () {
    local kubeconfig="${KUBECONFIGS_DIRECTORY}/${1:?user-friendly kubeconfig file name}.yaml"
    local default_kubeconfig="${KUBECONFIG:-"${HOME}/.kube/config"}"
    if ! [ -f "${kubeconfig}" ]; then
        error "Kubeconfig ${kubeconfig} does not exist. Fetch it first."
        return 1
    fi
    if [ -f "${default_kubeconfig}" ]; then
        cmd mv "${default_kubeconfig}" "${default_kubeconfig}.bak"
    fi
    cmd ln -s "${kubeconfig}" "${default_kubeconfig}"
}

ip () {
    local kubeconfig="${KUBECONFIGS_DIRECTORY}/${1:?user-friendly kubeconfig file name}.yaml"
    local new_ip="${2:?}"
    cmd sed -i "'s|\(.*server:.*https://\).*\(:.*\)|\1${new_ip}\2|g'" "${kubeconfig}"
}

[[ $# -ge 2 ]] || usage
while [ $# -gt 0 ]; do
    case "$1" in
        fetch)
            [ $# -eq 3 ] || usage
            fetch "$2" "$3"
            shift 3
            ;;
        ip)
            [ $# -eq 3 ] || usage
            ip "$2" "$3"
            shift 3
            ;;
        edit)
            [ $# -eq 2 ] || usage
            edit "$2"
            shift 2
            ;;
        use)
            [ $# -eq 2 ] || usage
            use "$2"
            shift 2
            ;;
        *)
            usage
    esac
done
