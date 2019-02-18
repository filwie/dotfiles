#!/usr/bin/env zsh
# vim: set ft=zsh sw=2 ts=2:

# source zshrc variables
eval "$(head -n 12 ${0:A:h}/home/zshrc)"

MINI_DOTFILES="${0:A:h}"

function info_msg () {
  echo -e "$(tput setaf 3)${1}$(tput sgr0)"
}

function error_msg () {
  echo -e "$(tput setaf 3)${1}$(tput sgr0)" > /dev/stderr
  return "${1:-1}"
}

function run_log_cmd () {
  echo -e "$(tput setaf 12)[$(date +'%H:%M:%S')] RUNNING: ${1}$(tput sgr0)"
  eval "${1}"
}


function link_mini_dotfiles () {
  pushd "${MINI_DOTFILES}" > /dev/null
  for dotfile in ./home/*; do
    local _src="${dotfile:A}"
    local _target="${HOME}/.${dotfile:t}"
    if [[ "${_src}" =~ .*.zsh-theme ]]; then
      _target="${ZSH_THEMES}/${_src:t}"
    fi
    if [[ "${_src:t}" == "vimrc" ]]; then
      local _nvim_init
      _nvim_init="${XDG_CONFIG_HOME:-${HOME}/.config}/nvim/init.vim"
      [[ -f "${_nvim_init}" ]] && rm "${_nvim_init}"
      [[ -d "${_nvim_init:A:h}" ]] || run_log_cmd "mkdir -p ${_nvim_init:A:h}"
      run_log_cmd "ln -s ${_src} ${_nvim_init}"
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
                   "${ZSH}"
  install_from_url "git" \
                   "https://github.com/junegunn/fzf.git" \
                   "${FZF}" \
                   "${FZF}/install --no-completion --no-key-bindings --no-bash --no-fish --no-zsh --no-update-rc"
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
  install_from_url "git" \
                   "https://github.com/zsh-users/zsh-autosuggestions" \
                   "${ZSH_PLUGINS}/zsh-autosuggestions"
  install_from_url "git" \
                   "https://github.com/zdharma/fast-syntax-highlighting.git" \
                   "${ZSH_PLUGINS}/fast-syntax-highlighting"

}

function main () {
  install_utilities
  link_mini_dotfiles
}

main
