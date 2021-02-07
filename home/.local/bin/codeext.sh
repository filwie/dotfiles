#!/usr/bin/env bash

CODE_EXTENSIONS_LIST="${XDG_CONFIG_HOME:-"${HOME}/.config"}/Code/User/extensions.list"

code --list-extensions | tee "${CODE_EXTENSIONS_LIST}"
