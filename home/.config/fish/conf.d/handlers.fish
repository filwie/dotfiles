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

set -gx _python_ver (string match -r '\d+.\d+[.\d]*' (command python -V 2>&1))
function _set_python_venv_ver --on-variable VIRTUAL_ENV
    switch $argv[2]
    case 'ERASE'
        set -e _python_venv
        set -gx _python_ver (string match -r '\d+.\d+[.\d]*' (command python -V 2>&1))
    case 'SET'
        if test -x $VIRTUAL_ENV/bin/python
            set -gx _python_venv (basename $VIRTUAL_ENV 2>&1)
            set -gx _python_ver (string match -r '\d+.\d+[.\d]*' ($VIRTUAL_ENV/bin/python -V 2>&1))
        end
    end
end
