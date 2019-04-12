## #TODO
- [ ] automate https://github.com/sebastianmarkow/deoplete-rust, https://github.com/racer-rust/racer
- [ ] autocd in fish

## Prerequirements
###### Packages
``` sh
vim tmux zsh ncurses
```
###### Fonts
One of [NERD Fonts](https://nerdfonts.com/). I prefer Iosevka.

###### Terminal emulator
One that supports emoji (only used in Docker container so kind of optional) and NERD font glyphs (best effect with double-width characters).
I personally recommend `alacritty` or `terminator` on Linux and `iTerm2` on Mac OS.

###### Using `wisp` Zsh theme without the rest of dotfiles
For theme to work copy functions from `UTILS` section of `zshrc` to the top of `wisp.zsh-theme`.

## Quickstart
###### HTTPS
``` sh
git clone --depth 1 "https://github.com/filwie/mini-dotfiles.git" "${HOME}/.mini-dotfiles" && ${HOME}/.mini-dotfiles/install.sh
```

###### SSH
``` sh
git clone "git@github.com:filwie/mini-dotfiles.git" "${HOME}/.mini-dotfiles" && ${HOME}/.mini-dotfiles/install.sh
```

## Description
This repository contains minimal subset of all my dotfiles:
- Zsh (including custom theme)
- Vim
- Tmux

Zsh theme displays information about:
- [x] SSH connection
- [x] being in Docker container
- [x] having Python virtualenv activated (virtualenv name and Python version)
- [x] Python version outside of virtualenv (if desired)
- [x] OS (currently works for Raspbian, Arch, Mac OS, Ubuntu)

<img src="https://raw.githubusercontent.com/filwie/images/master/mini-dotfiles/zsh-theme-os.png" alt="zsh-theme-os" width="50%"/>

Root types in red. <b>How distinguishable!</b>

<img src="https://raw.githubusercontent.com/filwie/images/master/mini-dotfiles/zsh-theme-root.png" alt="zsh-theme-root" width="50%"/>

Git branch and status (clean/dirty):

<img src="https://raw.githubusercontent.com/filwie/images/master/mini-dotfiles/zsh-theme-git.png" alt="zsh-theme-git" width="50%"/>


## Configuration
#### Zsh theme configuration options
1. To pick box character set `ZSH_THEME_BOX_CHAR` env var to value from `1` to `5`.

<img src="https://raw.githubusercontent.com/filwie/images/master/mini-dotfiles/zsh-theme-box-char.png" alt="zsh-theme-box" width="50%"/>

2. To display Python version outside of virtual environments set `ZSH_THEME_ALWAYS_SHOW_PYTHON` env var to `1`.

<img src="https://raw.githubusercontent.com/filwie/images/master/mini-dotfiles/zsh-theme-python.png" alt="zsh-theme-python" width="50%"/>
