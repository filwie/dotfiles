# function _on_new_prompt --on-event fish_prompt
# end
#
# function _before_interactive_command --on-event fish_preexec
#     set -l cmd $argv
# end
#
# function _after_interactive_command --on-event fish_postexec
#     set -l cmd $argv
# end

function _git_get_remote_glyph  # {{{
    command -v git > /dev/null; or return
    if command git rev-parse --is-inside-work-tree > /dev/null 2>&1
        switch (command git remote get-url origin 2> /dev/null; or echo)
        case '*github.com*'
            set glyph ' '
            set color FFFFFF
        case '*gitlab.com*'
            set glyph ' '
            set color E24329
        case '*bitbucket.com*'
            set glyph ' '
            set color 2684FF
        case '*'
            set glyph ' '
            set color F05033
        end
        set_color $color
        printf '%s' $glyph
        set_color normal
    end
end  # }}}

set -gx _git_remote_glyph (_git_get_remote_glyph)
function _set_git_remote_glyph --on-variable PWD  # {{{
    set -q THEME_ENABLE_GLYPHS; or return
    command -v git > /dev/null; or return
    if command git rev-parse --is-inside-work-tree > /dev/null 2>&1
        set -gx _git_remote_glyph (_git_get_remote_glyph)
    else
        set -e _git_remote_glyph
    end
end  # }}}

if command -v python > /dev/null
    if not set -q _python_ver
        set -gx _python_ver (string match -r '\d+.\d+[.\d]*' (command python -V 2>&1))
    end
end
function _set_python_venv_ver --on-variable VIRTUAL_ENV  # {{{
    command -v python > /dev/null; or return
    switch $argv[2]
    case 'ERASE'
        set -gx _python_ver (string match -r '\d+.\d+[.\d]*' (command python -V 2>&1))
    case 'SET'
        if test -x $VIRTUAL_ENV/bin/python
            set -gx _python_venv (basename $VIRTUAL_ENV 2>&1)
            set -gx _python_ver (string match -r '\d+.\d+[.\d]*' ($VIRTUAL_ENV/bin/python -V 2>&1))
        end
    end
end  # }}}

if command -v go > /dev/null
    set -q _go_ver; or set -gx _go_ver (string match -r '\d+.\d+[.\d]*' (command go version 2>&1))
end
function _set_go_ver --on-variable GOROOT  # {{{
    command -v python > /dev/null; or return
    switch $argv[2]
    case 'ERASE'
        set -gx _go_ver (string match -r '\d+.\d+[.\d]*' (command go version 2>&1))
    case 'SET'
        if test -x $GOROOT/bin/go
            set -gx _go_ver (string match -r '\d+.\d+[.\d]*' ($GOROOT/bin/go version 2>&1))
        end
    end
end  # }}}
