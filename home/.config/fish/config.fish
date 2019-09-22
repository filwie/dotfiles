function _env_java -d 'Set JAVA_HOME and JAVA_BIN if exists'  # {{{
    set _java_dir_linux /usr/lib/jvm/java-8-openjdk-amd64/
    if test -d $_java_dir_linux
        set JAVA_HOME $_java_dir_linux
        set JAVA_BIN $JAVA_HOME/bin
    end
end  # }}}

function _env_editors -d 'Export (Neo)Vim and Emacs variables'  # {{{
    # vim
    set -gx EDITOR nvim
    set -gx VIM_SHELL (which sh)
    set -gx NVIM_TUI_ENABLE_TRUE_COLOR 1
end  # }}}

function _env_all -d 'Set environment variables'  # {{{
    set -q XDG_CONFIG_HOME; or set -gx XDG_CONFIG_HOME $HOME/.config

    # fzf
    set -gx FZF_BASE $XDG_CONFIG_HOME/fzf

    # Tmux
    set -gx TMUX_SHELL (which fish)

    # Fish itself
    set -gx FISH_DIR $XDG_CONFIG_HOME/fish

    # SSH detection
    if set -q SSH_CLIENT || set -q SSH_TTY
        set -gx REMOTE_SESSION true
    end

    _env_java
    _env_editors
end  # }}}

function _source_other_files  -d 'Source path config and aliases'  # {{{
    source $FISH_DIR/path.fish
    source $FISH_DIR/alias.fish
end  # }}}

function _start_or_attach_tmux  -d 'Start new tmux session or attach to existing one'  # {{{
    if set -q EMBEDED_TERMINAL;
    or not test -x (command -v tmux);
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

function _workon_default_venv -d 'Source default Python3 venv'  # {{{
    if not set -q always_start_venv; return; end
    set def_venv_activate $HOME/python/main/bin/activate.fish
    if test -f $def_venv_activate
        source $def_venv_activate
    end
end  # }}}

function _install_fisher -d 'Make sure Fisher is installed'  # {{{
    if not functions -q fisher
        set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
        curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
        fish -c fisher
    end
end  # }}}

function main
    set -g fish_greeting
    #    set -g always_start_tmux
    set -g always_start_venv
    set -e fish_theme_always_show_python
    set -g fish_theme_enable_glyphs
    set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

    _env_all
    _source_other_files
    _start_or_attach_tmux
    _workon_default_venv
end

main
