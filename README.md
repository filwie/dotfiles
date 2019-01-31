<img src="https://raw.githubusercontent.com/filwie/images/master/mini-dotfiles/logo.gif" alt="logo" width="100%"/>

## Prerequirements
###### Packages
``` sh
vim tmux zsh [grc] ncurses
```
###### Fonts
One of [NERD Fonts](https://nerdfonts.com/). I prefer Iosevka.

###### Terminal emulator
One that supports emoji and NERD font glyphs (best effect with double-width characters.
I personally recommend `terminator` on Linux and `iTerm2` on Mac OS.

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
- Zsh (including custom theme)
- Vim
- Tmux

Including easily customizable [box characters](https://en.wikipedia.org/wiki/Box-drawing_character)

<img src="https://raw.githubusercontent.com/filwie/images/master/mini-dotfiles/zsh-theme-box.png" alt="zsh-theme-box" width="100%"/>

Zsh theme detects and displays information about:
- [x] running via SSH
- [x] running in Docker container
- [x] having Python virtualenv activated

<img src="https://raw.githubusercontent.com/filwie/images/master/mini-dotfiles/zsh-theme-detect.png" alt="zsh-theme-detect" width="100%"/>

Root types in red. <span style="color:red"><b>How distinguishable!</b></span>

<img src="https://raw.githubusercontent.com/filwie/images/master/mini-dotfiles/zsh-theme-root.png" alt="zsh-theme-root" width="100%"/>

## Other software
#### Mac OS
``` sh
brew install zsh vim macvim moreutils coreutils wget ranger multitail fd tree unzip unrar p7zip curl multitail fd tree links curl p7zip unrar unzip highlight mutt cmus imagemagick go htop iftop tcl-tk cmake cppcheck shellcheck ansible-lint rust docker-compose docker-completion docker-compose-completion
```

#### Arch Linux
``` sh
sudo pacman -S
```

#### Ubuntu (18.04)
```
sudo apt install
```


# #TODO
- [x] fix changing cursor from block to bar in `INSERT` mode (should be OS independent and gvim/macvim/vim compliant)
- [ ] hide output of git clone etc - only display OK/FAIL - the rest should be in log file
      (that could be in repo in ignored logs dir or in /tmp) log should be displayed if installation fails
- [x] improve setup script - add some feedback about what it does, handle existing target file
- [ ] provide list of packages for Linux, check if there are no missing packages for Mac
- [x] what about ZSH theme that is not in this repo? <i>added to repo</i>
