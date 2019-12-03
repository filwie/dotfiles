set -q XDG_CONFIG_HOME; or set -gx XDG_CONFIG_HOME $HOME/.config
set -q XDG_DATA_HOME; or set -gx XDG_DATA_HOME $HOME/.local/share
set -q XDG_CACHE_HOME; or set -gx XDG_CACHE_HOME $HOME/.cache

set -gx EDITOR nvim
set -gx NVIM_TUI_ENABLE_TRUE_COLOR 1

set -gx VIM_SHELL (command -v sh)
set -gx TMUX_SHELL (command -v fish)

set -gx CARGO_HOME $XDG_DATA_HOME/cargo

set -gx NIM_HOME $XDG_DATA_HOME/nim
set -gx NIMBLE_HOME $XDG_DATA_HOME/nimble

set -gx GOPATH $XDG_DATA_HOME/go

set -gx FZF_BASE $XDG_CONFIG_HOME/fzf
set -gx FISH_DIR $XDG_CONFIG_HOME/fish

set -g fish_greeting
set -e fish_theme_always_show_python
set -g fish_theme_enable_glyphs
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

set -gx ANSIBLE_CONFIG $XDG_CONFIG_HOME/ansible/ansible.cfg

set -g FZF_CTRL_T_COMMAND "command find -L \$dir -type f -not -path '*/\.git/*' 2> /dev/null | sed '1d; s#^\./##'"
set -gx FZF_DEFAULT_COMAND "command find . -not -path '*/\.git/*'"

set -gx GNUPGHOME $XDG_DATA_HOME/gnupg
