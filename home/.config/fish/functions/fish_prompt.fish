# vars {{{
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

set __fish_git_prompt_show_informative_status
set __fish_git_prompt_showcolorhints
set __fish_git_prompt_showupstream 'auto'
set __fish_git_prompt_showdirtystate 1

if set -q THEME_ENABLE_GLYPHS
    set __fish_git_prompt_char_upstream_prefix ''
    set __fish_git_prompt_char_upstream_ahead  '↑'
    set __fish_git_prompt_char_upstream_behind '↓'
    set __fish_git_prompt_char_stateseparator  ''
    set __fish_git_prompt_char_dirtystate      '✚'
    set __fish_git_prompt_char_invalidstate    '✖'
    set __fish_git_prompt_char_stagedstate     '●'
    set __fish_git_prompt_char_untrackedfiles  '…'
    set __fish_git_prompt_char_stashstate      '⚑'
    set __fish_git_prompt_char_cleanstate      '✔'
else
    set __fish_git_prompt_char_upstream_prefix ''
    set __fish_git_prompt_char_upstream_ahead  '↑'
    set __fish_git_prompt_char_upstream_behind '↓'
    set __fish_git_prompt_char_stateseparator  ''
    set __fish_git_prompt_char_dirtystate      '✚'
    set __fish_git_prompt_char_invalidstate    '✖'
    set __fish_git_prompt_char_stagedstate     '●'
    set __fish_git_prompt_char_untrackedfiles  '…'
    set __fish_git_prompt_char_stashstate      '⚑'
    set __fish_git_prompt_char_cleanstate      '✔'
end
# /vars }}}

# os glyph, os detection {{{

## known_oses {{{
set -q known_oses; or set -g known_oses \
    arch \
    bsd \
    centos \
    debian \
    fedora \
    linux \
    mac \
    manjaro \
    opensuse \
    raspbian \
    redhat \
    ubuntu \
    unknown
## /known_oses }}}

## known_oses_colors {{{
set -q known_oses_colors; or set -g known_oses_colors \
    0F94D2 \
    770000 \
    EFA724 \
    C70036 \
    00457E \
    000000  \
    FFFFFF \
    35BF5C \
    73BA25 \
    C31C4A \
    EE0000 \
    E95420 \
    AEAEAE
## /known_oses_colors }}}

## known_oses_glyphs {{{
set -q known_oses_glyphs; or set -g known_oses_glyphs \
    (printf '%s%s%s' (set_color 0F94D2 ) ' ' (set_color normal))\
    (printf '%s%s%s' (set_color 770000 ) ' ' (set_color normal)) \
    (printf '%s%s%s' (set_color EFA724 ) ' ' (set_color normal)) \
    (printf '%s%s%s' (set_color C70036 ) ' ' (set_color normal)) \
    (printf '%s%s%s' (set_color 00457E ) ' ' (set_color normal)) \
    (printf '%s%s%s' (set_color 000000 ) ' ' (set_color normal)) \
    (printf '%s%s%s' (set_color FFFFFF ) ' ' (set_color normal)) \
    (printf '%s%s%s' (set_color 35BF5C ) ' ' (set_color normal)) \
    (printf '%s%s%s' (set_color 73BA25 ) ' ' (set_color normal)) \
    (printf '%s%s%s' (set_color C31C4A ) ' ' (set_color normal)) \
    (printf '%s%s%s' (set_color EE0000 ) ' ' (set_color normal)) \
    (printf '%s%s%s' (set_color E95420 ) ' ' (set_color normal)) \
    (printf '%s%s%s' (set_color AEAEAE ) '' (set_color normal))
## /known_oses_glyphs }}}

set -g known_os_regex (printf '%s' (string join '|' $known_oses))

function _distro
    if not set -q THEME_DISTRO
        if test -f /etc/os-release
            set -gx THEME_DISTRO (string lower (string match -ir $known_os_regex (head -n1 /etc/os-release))); or set -gx THEME_DISTRO 'linux'
        end
    end
    printf '%s' $THEME_DISTRO
end

function _os -d "Detect os type (and Linux distro if linux)"  # {{{
    if not set -q THEME_OS
        switch (uname)
        case Linux
            set -gx THEME_OS (_distro)
        case Darwin
            set -gx THEME_OS mac
        case '*'
            set -gx THEME_OS other
        end
    end
    printf $THEME_OS
end  # }}}

function _os_glyph
    set -q THEME_ENABLE_GLYPHS; or return
    if not set -q THEME_OS_GLYPH
        set index (contains -i (_os) $known_oses)
        set -gx THEME_OS_GLYPH $known_oses_glyphs[$index]
    end
    printf $THEME_OS_GLYPH
end

function _os_color
    if not set -q THEME_OS_COLOR
        set index (contains -i (_os) $known_oses)
        set -gx THEME_OS_COLOR $known_oses_colors[$index]
    end
    printf $THEME_OS_COLOR
end
# /os glyph, os detection }}}

function _prompt_end  # {{{
    if set -q THEME_ENABLE_GLYPHS
        set_color (_os_color)
    else
        set_color blue
    end
    test $RC -eq 0; or set_color red
    set_color --bold
    if test (id -u) -eq 0; printf "#"
    else; printf ">"; end
    set_color normal
end  # }}}

function _err_code  # {{{
    if test $RC -gt 0
        printf '%s%s%s' (set_color --bold red) $RC (set_color normal)
    end
end  # }}}

function _incolor  # {{{
    test (count $argv) -eq 2; or return
    printf '%s%s%s' (set_color $argv[1]) $argv[2] (set_color normal)
end  # }}}

function _git_remote_glyph  # {{{
    set -q THEME_ENABLE_GLYPHS; or return
    command -v git > /dev/null; or return
    if command git rev-parse --is-inside-work-tree > /dev/null 2>&1
        switch (command git remote get-url origin 2> /dev/null; or echo)
        case '*github.com*'
            set dir_glyph ' '
            set dir_glyph_color FFFFFF
        case '*gitlab.com*'
            set dir_glyph ' '
            set dir_glyph_color E24329
        case '*bitbucket.com*'
            set dir_glyph ' '
            set dir_glyph_color 2684FF
        case '*'
            set dir_glyph ' '
            set dir_glyph_color F05033
        end
    end
    printf '%s%s%s' (set_color $dir_glyph_color) $dir_glyph (set_color normal)
end  # }}}

function _path  # {{{
    printf '%s%s%s' (set_color --bold) (prompt_pwd) (set_color normal)
end  # }}}

function _jobs  # {{{
    test $NJOBS -gt 0; or return
    printf '%sj:%s%s' (set_color --bold brblue) $NJOBS (set_color normal)
end  # }}}

function _running_docker_containers  # {{{
    command -v docker > /dev/null; or return
    set_color 099CEC
    if set -q THEME_ENABLE_GLYPHS
        printf '  '
    end
    docker ps -q 2> /dev/null | wc -l
    set_color normal
end  # }}}

# language versions {{{
function _python_venv  # {{{
    if set -q VIRTUAL_ENV
        set -q __venv; or set -g __venv (basename $VIRTUAL_ENV)
        printf "%s" $__venv
    end
end  # }}}

function _python_version  # {{{
    command -v python > /dev/null; or return
    if set -q THEME_ENABLE_GLYPHS
        set_color FFDC54
        printf '  '
    end
    set_color 3E7BAC
    string match -r '\d+.\d+[.\d]*' (command python -V 2>&1)
end  # }}}

function _go_version  # {{{
    command -v go > /dev/null; or return
    set_color 7FD5EA
    if set -q THEME_ENABLE_GLYPHS
        printf ' '
    end
    string match -r '\d+.\d+[.\d]*' (command python -V 2>&1)
end  # }}}
# language versions }}}

function fish_prompt --description 'Write out the prompt'
    set -g RC $status
    set -g NJOBS (jobs -c | wc -l)

    _os_glyph       ; printf ' '
    _jobs           ; printf ' '
    _path           ; printf ' '
    _prompt_end     ; printf ' '
end

function fish_right_prompt
    _err_code                  ; printf ' '
    _git_remote_glyph          ; printf ' '
    __fish_git_prompt "%s"     ; printf ' '
    _go_version                ; printf ' '
    _python_version            ; printf ' '
    _python_venv
    _running_docker_containers
end
