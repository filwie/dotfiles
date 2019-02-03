#!/usr/bin/env zsh
# vim: set ft=zsh sw=2 ts=2:

local log_file="/tmp/mini_dotfiles$(date)"

local mini_dotfiles="${HOME}/.mini-dotfiles"
local mini_dotfiles_repo_ssh="git@github.com:filwie/mini-dotfiles.git"
local mini_dotfiles_repo_https="https://github.com/filwie/mini-dotfiles.git"

local zsh_themes="${HOME}/.oh-my-zsh/custom/themes"

function info_msg () {
  echo -e "$(tput setaf 3)${1}$(tput sgr0)"
}

function error_msg () {
  echo -e "$(tput setaf 3)${1}$(tput sgr0)" > /dev/stderr
  return "${1:-1}"
}

function run_log_cmd () {
  local cmd
  cmd="${1}"
  echo -e "$(tput setaf 12)[$(date +'%H:%M:%S')] RUNNING: ${cmd}$(tput sgr0)"
  eval "${cmd}"
}

function clone_mini_dotfiles () {
  local repo_url
  repo_url="${1}"
  if ! [[ -d "${mini_dotfiles}" ]]; then
    run_log_cmd "git clone ${repo_url} ${mini_dotfiles}"
  fi
}

function link_mini_dotfiles () {
  pushd "${mini_dotfiles}" > /dev/null
  for dotfile in ./home/*; do
    local _src="${dotfile:A}"
    local _target="${HOME}/.${dotfile:t}"
    if [[ "${_src}" =~ .*.zsh-theme ]]; then
      _target="${zsh_themes}/${_src:t}"
    fi
    [[ -L "${_target}" ]] && run_log_cmd "rm ${_target}"
    [[ -f "${_target}" ]] && run_log_cmd "mv ${_target} ${_target}.bak"
    run_log_cmd "ln -s ${_src} ${_target}"
  done
  popd > /dev/null
}

function install_from_url () {
  local cmd url dest install_script
  cmd="${1}"
  url="${2}"
  dest="${3}"
  install_script="${4}"

  if [[ -e "${dest}" ]]; then
    info_msg "${dest} found. Skipping..."
    return
  fi

  case "${cmd}" in
    git)
      run_log_cmd "git clone --depth=1 ${url} ${dest}" ;;
    curl)
      run_log_cmd "curl -fLo ${dest} --create-dirs ${url}" ;;
    *)
      return 1
      ;;
  esac

  [[ -n "${install_script}" ]] && run_log_cmd "${install_script}"
}

function install_utilities () {
  install_from_url "git"\
                   "https://github.com/robbyrussell/oh-my-zsh.git" \
                   "${HOME}/.oh-my-zsh"
  install_from_url "git" \
                   "https://github.com/junegunn/fzf.git" \
                   "${HOME}/.fzf" \
                   "${HOME}/.fzf/install --all --no-bash --no-fish --no-update-rc"
  install_from_url "git" \
                   "https://github.com/tmux-plugins/tpm" \
                   "${HOME}/.tmux/plugins/tpm" \
                   "${HOME}/.tmux/plugins/tpm/bin/install_plugins"
  install_from_url "curl" \
                   "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" \
                   "${HOME}/.vim/autoload/plug.vim" \
                   "vim +silent +PlugInstall +qall"
  install_from_url "curl" \
                   "https://raw.githubusercontent.com/JDevlieghere/dotfiles/master/.vim/.ycm_extra_conf.py" \
                   "${HOME}/.vim/.ycm_extra_conf.py"
}

function main () {
  clone_mini_dotfiles "${mini_dotfiles_repo_ssh}" \
    || clone_mini_dotfiles "${mini_dotfiles_repo_https}"
  install_utilities
  link_mini_dotfiles
}

main
