#!/usr/bin/env zsh
# vim: set ft=zsh sw=2 ts=2:

local script_path="${0:h:A}"
local mini_dotfiles="${HOME}/.mini-dotfiles"

function link_mini_dotfiles () {
  pushd "${script_path}" > /dev/null
  for dotfile in home/*; do
    local _src="$(realpath ${dotfile})"
    local _target="${HOME}/.$(basename ${dotfile})"
    ln -s "${_src}" "${_target}"
  done
  popd > /dev/null
}

function install_utilities () {
  if ! [[ -d ${HOME}/.oh-my-zsh ]]; then
    git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git ${HOME}/.oh-my-zsh
  fi

  if ! [[ -d "${HOME}/.fzf" ]]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ${HOME}/.fzf
    ${HOME}/.fzf/install --all --no-update-rc
  fi

  if ! [[ -d "${HOME}/.tmux/plugins/tpm" ]]; then
    git clone --depth 1 https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm
    ${HOME}/.tmux/plugins/tpm/bin/install_plugins
  fi

  if ! [[ -f "${HOME}/.vim/autoload/plug.vim" ]]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    vim +silent +PlugInstall +qall
  fi
}

link_mini_dotfiles
install_utilities
