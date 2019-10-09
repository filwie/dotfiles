#!/usr/bin/env bash
set -eu

REPO_ROOT="$(git rev-parse --show-toplevel)"
BUILD_DIR="${REPO_ROOT}"
DOCKER_DIR="${REPO_ROOT}/docker"

IMAGE_TAG="${IMAGE_TAG:-latest}"
IMAGE_PREFIX="${IMAGE_PREFIX:-dotfiles-}"
IMAGE_SUFFIX="${IMAGE_SUFFIX:-""}"

function cprintf () {
    [ $# -lt 2 ] && return
    tput setaf "${1}"; shift
    # shellcheck disable=SC2059
    printf "${@}"
    tput sgr0
}

function info () { cprintf 2 "${@}"; }
function warning () { cprintf 3 "${@}"; }
function error () { cprintf 1 "${@}"; }
function run_log () { info "Running: ${*} ($(basename "$(pwd)"))\n"; eval "${@}"; }

function generate_dockerfiles () {
    "${DOCKER_DIR}/generate_dockerfiles.py"
}

function build_images () {
    local image_name build_cmd
    pushd "${BUILD_DIR}" > /dev/null
    for dockerfile in "${DOCKER_DIR}"/**/Dockerfile; do
        image_name="${IMAGE_PREFIX}$(basename "$(dirname "${dockerfile}")")${IMAGE_SUFFIX}"
        dockerfile_relpath="$(realpath --relative-to="${BUILD_DIR}" "${dockerfile}")"
        build_cmd="docker build . --file ${dockerfile_relpath} --tag ${image_name}:${IMAGE_TAG}"
        run_log "${build_cmd}"
    done
    popd >/dev/null
}

function main () {
    generate_dockerfiles
    build_images
}

main
