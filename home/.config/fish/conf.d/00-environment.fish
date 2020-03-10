
set -q XDG_CONFIG_HOME; or set -gx XDG_CONFIG_HOME $HOME/.config
set -q XDG_DATA_HOME; or set -gx XDG_DATA_HOME $HOME/.local/share
set -q XDG_CACHE_HOME; or set -gx XDG_CACHE_HOME $HOME/.cache

set -gx EDITOR nvim
set -gx NVIM_TUI_ENABLE_TRUE_COLOR 1

set -gx VIM_SHELL (command -v sh)
set -gx TMUX_SHELL (command -v fish)
set -gx TMUX_PLUGIN_MANAGER_PATH $XDG_DATA_HOME/tmux/plugins

set -gx CARGO_HOME $XDG_DATA_HOME/cargo

set -gx NIM_HOME $XDG_DATA_HOME/nim
set -gx NIMBLE_HOME $XDG_DATA_HOME/nimble

set -gx GOPATH $XDG_DATA_HOME/go

set -gx GEM_HOME $XDG_DATA_HOME/gem
set -gx GEM_SPEC_CACHE $XDG_CACHE_HOME/gem

set -gx FZF_BASE $XDG_DATA_HOME/fzf
# set -gx FZF_CTRL_T_OPTS $FZF_CTRL_T_OPTS "--preview 'bat --theme=ansi-dark --style=numbers,changes --color=always {} | head -n 100'"
set -gx FZF_CTRL_T_OPTS $FZF_CTRL_T_OPTS "--preview 'highlight --stdout --force --out-format ansi {} | head -n 100'"

set -g FZF_CTRL_T_COMMAND "command find -L \$dir -type f -not -path '*/\.git/*' 2> /dev/null | sed '1d; s#^\./##'"
set -gx FZF_DEFAULT_COMAND "command find . -not -path '*/\.git/*'"
if set -q __theme_color0
    set -gx FZF_DEFAULT_OPTS $FZF_DEFAULT_OPTS "--color=16,border:$__theme_color8,hl:$__theme_url_color,hl+:$__theme_url_color,bg+:$__theme_color0,spinner:$__theme_color8" \
                                               "--height=40%"
end


set -gx FISH_DIR $XDG_CONFIG_HOME/fish
# set -gx FISH_ENABLE_VI_MODE 1

set -g fish_greeting
set -e fish_theme_always_show_python
set -g fish_theme_enable_glyphs
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

set -gx ANSIBLE_CONFIG $XDG_CONFIG_HOME/ansible/ansible.cfg

set -gx GNUPGHOME $XDG_DATA_HOME/gnupg

set -gx GRIPHOME $XDG_DATA_HOME/grip
set -gx SOLARGRAPH_CACHE $XDG_CACHE_HOME/solargraph

set -gx PYENV_ROOT $XDG_DATA_HOME/pyenv
