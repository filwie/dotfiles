#!/usr/bin/env zsh
export MINI_DOTFILES="${0:A:h}"

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"

export ZSH_XDG="${XDG_CONFIG_HOME}/zsh"
export HISTFILE="${ZSH_XDG}/history"
export ZSH_COMPDUMP="${ZSH_XDG}/cache/"
export ZSH="${ZSH_XDG}/oh-my-zsh"
export FZF="${XDG_CONFIG_HOME}/fzf"
export FZF_BASE="${FZF}"

export ZSH_THEME="wisp"
export ZSH_CUSTOM="${ZSH_CUSTOM:-${ZSH}/custom}"
export ZSH_THEMES="${ZSH_CUSTOM}/themes"
export ZSH_PLUGINS="${ZSH_CUSTOM}/plugins"
