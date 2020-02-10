#!/usr/bin/env bash
sep () {
    printf "\n\n"
    eval "printf '=%.0s' {1..$(tput cols)}"
    printf "\n\n"
}

sep
xclip -selection clipboard -out
sep

read -rp "Run above snippet? [Y/n] " choice

if [[ "${choice}" =~ ^(Y|y||"\n")$ ]]; then
    xclip -selection clipboard -out | bash
fi
