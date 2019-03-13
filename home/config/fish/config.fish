function _env_java
    set _java_dir_linux /usr/lib/jvm/java-11-openjdk-amd64/bin/
    if test -d $_java_dir_linux
        set JAVA_HOME $_java_dir_linux
        set JAVA_BIN $JAVA_HOME/bin
    end
end

function _environment
    set -q XDG_CONFIG_HOME; or set -gx XDG_CONFIG_HOME $HOME/.config
    set -gx FZF_BASE $XDG_CONFIG_HOME/fzf
    set -gx FISH_DIR $XDG_CONFIG_HOME/fish

    set -gx VIRTUAL_ENV_DISABLE_PROMPT 1
    set -gx TMUX_SHELL (which fish)
    set -gx VIM_SHELL (which sh)
    set -gx NVIM_TUI_ENABLE_TRUE_COLOR 1
    if command -v nvim > /dev/null
        set -gx VIM_CONF $XDG_CONFIG_HOME/nvim/init.vim
    else
        set -gx VIM_CONF $HOME/.vimrc
    end
    if test -f $XDG_CONFIG_HOME/tmux/tmux.conf
        set -gx TMUX_CONF $XDG_CONFIG_HOME/tmux/tmux.conf
    else
        set -gx TMUX_CONF $HOME/.tmux.conf
    end
    set -gx FISH_CONF $FISH_DIR/config.fish
    if set -q SSH_CLIENT || set -q SSH_TTY
        set -g REMOTE_SESSION 1
    end

    _env_java

    set -g fish_greeting
    set -g always_start_tmux
    set -e fish_theme_always_show_python
    set -g fish_theme_enable_glyphs
end

function _source_other_files
    source $FISH_DIR/path.fish
    source $FISH_DIR/alias.fish
end

function _start_or_attach_tmux
    if set -q EMBEDED_TERMINAL;
    or not test -x (command -v tmux);
    or not set -q always_start_tmux;
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
end

function main
    _environment
    _source_other_files
    _start_or_attach_tmux
end

main
