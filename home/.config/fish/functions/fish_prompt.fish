function _glyph -d 'Print glyph+whitespace conditionally'  # {{{
    if set -q glyph && set -q fish_theme_enable_glyphs
        printf "%s" $glyph
        if test (count $argv) -eq 1
            printf "%s" $argv[1]
        end
    end
end  # }}}

function _segment -d 'Print segment surrounded by separators'  # {{{
    if test (count $argv) -ne 1; return; end
    if not set -q separator;
        set separator ' '
    end
    if test -n $argv[1]
        printf "%s%s" $argv[1] $separator
    end
end  # }}}

function _i; set_color -i; end
function _b; set_color -o; end
function _u; set_color -u; end
function _c; set_color $argv[1]; end
function _r; set_color normal; end

function _path -d 'Display shortened path'  # {{{
    set -g glyph 
    printf "%s%s" (_glyph '  ')(prompt_pwd)
end  # }}}

function _git -d 'Display branch in green/red depending on status'  # {{{
    if not __git_is_repo; return; end
    set -g glyph 
    set branch (__git_branch)

    if not __git_is_clean; _c bryellow; end
    printf "%s%s" (_glyph ' ')(_r) (_i)$branch(_r)
    set_color normal
end  # }}}

function _ssh -d 'Display info if connected via SSH'  # {{{
    if not _is_remote; return; end
    set -g glyph 
    _glyph
    printf (_i)"SSH"(_r)
end  # }}}

function _docker -d 'Display hostname if host is docker container'  # {{{
    if not _docker_is_container; return; end
    set -g glyph 
    set_color blue
    _glyph
    printf "%s" (_i)(hostname)(_r)
    set_color normal
end  # }}}

function _python -d 'Display venv name and Python version info'  # {{{
    if not test (command -v python); return; end
    set -g glyph 
    set python_version (__python_version)
    set venv (__python_venv)
    if set -q VIRTUAL_ENV || set -q fish_theme_always_show_python
        set_color brblue
        _glyph '  '
        set_color normal
        printf "%s%s" $python_version \ \((set_color -o)$venv(set_color normal)\)
     end
end  # }}}

function _end -d 'Prompt end character'  # {{{
    if set -q fish_theme_enable_glyphs
        if test (id -u) -eq 0
            set end_char 
        else
            set end_char 
        end
    else
        if test (id -u) -eq 0
            set end_char (_b)\#(_r)
        else
            set end_char (_b)\$(_r)
        end
    end

    if test $RETURN_VALUE -ne 0
        set_color brred
    end
    printf "%s" $end_char
    set_color normal
end  # }}}

function _prompt
    printf " %s%s%s%s " (_segment (_path)) (_segment (_git)) (_segment (_python)) (_end)
end

function fish_prompt
    set -g RETURN_VALUE $status
    _prompt
    set -e glyph
end
