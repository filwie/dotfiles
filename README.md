# mini-dotfiles

## Quickstart
###### HTTPS
``` sh
git clone --depth 1 "https://github.com/filwie/mini-dotfiles.git" "${HOME}/.mini-dotfiles" && ${HOME}/.mini-dotfiles/install.sh
```

###### SSH
``` sh
git clone --depth 1 "git@github.com:filwie/mini-dotfiles.git" "${HOME}/.mini-dotfiles" && ${HOME}/.mini-dotfiles/install.sh
```

## Description
This repository contains minimal subset of all my dotfiles:
- Zsh
- Vim
- Tmux




## Other software
#### Mac OS
``` sh
brew install zsh vim macvim moreutils coreutils wget ranger multitail fd tree unzip unrar p7zip curl multitail fd tree links curl p7zip unrar unzip highlight mutt cmus imagemagick go htop iftop tcl-tk cmake cppcheck shellcheck ansible-lint rust docker-compose docker-completion docker-compose-completion
```

#### Arch Linux

#### Ubuntu (18.04)


# #TODO
- [ ] fix changing cursor from block to bar in `INSERT` mode (should be OS independent and gvim/macvim/vim compliant)
- [ ] improve setup script - add some feedback about what it does, handle existing target file
- [ ] provide list of packages for Linux, check if there are no missing packages for Mac
- [ ] what about ZSH theme that is not in this repo?
