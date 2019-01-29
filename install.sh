#!/usr/bin/env zsh
# vim: set ft=zsh sw=2 ts=2:

local log_file="/tmp/mini_dotfiles$(date)"

local mini_dotfiles="${HOME}/.mini-dotfiles"
local mini_dotfiles_repo_ssh="git@github.com:filwie/mini-dotfiles.git"
local mini_dotfiles_repo_https="https://github.com/filwie/mini-dotfiles.git"

local zsh_themes="${HOME}/.oh-my-zsh/themes"

function info_msg () {
  echo -e "$(tput setaf 3)${1}$(tput sgr0)"
}

function run_log_cmd () {
  # display command that is going to be ran and run it
  # ARGS:
  # 1 - cmd
  local cmd="${1}"
  echo -e "$(tput setaf 12)[$(date +'%H:%M:%S')] RUNNING: ${cmd}$(tput sgr0)"
  eval "${cmd}"
}

function clone_mini_dotfiles () {
  # clone mini dotfiles repo if its destination directory does not exist
  # ARGS:
  # 1 - repo url
  local repo_url="${1}"
  if ! [[ -d "${mini_dotfiles}" ]]; then
    run_log_cmd "git clone ${repo_url} ${mini_dotfiles}"
  fi
}

function link_mini_dotfiles () {
  pushd "${mini_dotfiles}" > /dev/null
  for dotfile in home/*; do
    local _src="$(realpath ${dotfile})"
    local _target="${HOME}/.$(basename ${dotfile})"
    if [[ "${_src}" =~ ".*.zsh-theme" ]]; then
      _target="${zsh_themes}/$(basename ${_src})"
    fi
    [[ -L "${_target}" ]] && run_log_cmd "rm ${_target}"
    [[ -f "${_target}" ]] && run_log_cmd "mv ${_target} ${_target}.bak"
    run_log_cmd "ln -s ${_src} ${_target}"
  done
  popd > /dev/null
}

function install_util () {
  clone_url="${1}"
  clone_dest="${2}"
  script_to_run="${3:-''}"

  if [[ -d "${clone_dest}" ]]; then
    info_msg "${clone_dest} found. Skipping..."
    return
  fi

  run_log_cmd "git clone --depth=1 ${clone_url} ${clone_dest}"
  if [[ "${script_to_run}" != '' ]]; then
    run_log_cmd "${script_to_run}"
  fi
}

function install_utilities () {
  install_util "https://github.com/robbyrussell/oh-my-zsh.git" \
               "${HOME}/.oh-my-zsh"
  install_util "https://github.com/junegunn/fzf.git" \
               "${HOME}/.fzf" \
               "${HOME}/.fzf/install --all --no-bash --no-fish --no-update-rc"
  install_util "https://github.com/tmux-plugins/tpm" \
               "${HOME}/.tmux/plugins/tpm" \
               "${HOME}/.tmux/plugins/tpm/bin/install_plugins"

  if ! [[ -f "${HOME}/.vim/autoload/plug.vim" ]]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    vim +silent +PlugInstall +qall
  else
    info_msg "Vim plug already intalled. Skipping..."
  fi
}

function main () {
  clone_mini_dotfiles "${mini_dotfiles_repo_ssh}" \
    || clone_mini_dotfiles "${mini_dotfiles_repo_https}"
  install_utilities
  link_mini_dotfiles
}

main
