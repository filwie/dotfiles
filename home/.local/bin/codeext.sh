#!/usr/bin/env bash

REPO_PATH="$(realpath "$(dirname ${0})/../..")"
CODE_EXTENSIONS_LIST="${REPO_PATH}/home/.config/Code/User/extensions.list"

code --list-extensions | tee "${CODE_EXTENSIONS_LIST}"
