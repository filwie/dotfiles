set -gx EDITOR nvim
set -gx NVIM_TUI_ENABLE_TRUE_COLOR 1

set -gx VIM_SHELL (command -v sh)
set -gx TMUX_SHELL (command -v fish)


set -q XDG_CONFIG_HOME; or set -gx XDG_CONFIG_HOME $HOME/.config
set -q XDG_DATA_HOME; or set -gx XDG_DATA_HOME $HOME/.local/share
set -q XDG_CACHE_HOME; or set -gx XDG_CACHE_HOME $HOME/.cache

set -gx FZF_BASE $XDG_CONFIG_HOME/fzf
set -gx FISH_DIR $XDG_CONFIG_HOME/fish

set -g fish_greeting
set -e fish_theme_always_show_python
set -g fish_theme_enable_glyphs
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

function _start_or_attach_tmux  -d 'Start new tmux session or attach to existing one'  # {{{
    if not test -x (command -v tmux);
    or not set -q TMUX_ALWAYS;
        return
    end
    if test -z $TMUX
        set -l existing_session_id (tmux ls | grep -vm1 attached | cut -d: -f1)
        if test -z $existing_session_id
            tmux -2 new-session
        else
            tmux -2 attach-session -t $existing_session_id
        end
    end
end  # }}}

_start_or_attach_tmux
fish_vi_key_bindings
