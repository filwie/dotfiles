# vars {{{
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

set __fish_git_prompt_show_informative_status
set __fish_git_prompt_showcolorhints
set __fish_git_prompt_showupstream 'auto'
set __fish_git_prompt_showdirtystate 1
# set __fish_git_prompt_showstashstate 1

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
set -g known_oses \
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
set -g known_oses_colors \
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
set -g known_oses_glyphs \
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
    if test -f /etc/os-release
        string lower (string match -ir $known_os_regex (head -n1 /etc/os-release)); or printf 'linux'
    end
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
    set -l cn (docker ps -q | wc -l)
    printf '%s%s' $cn
end  # }}}

# language versions {{{
function _python_venv
    not set -q VIRTUAL_ENV; or printf "%s" (basename $VIRTUAL_ENV)
end

function _python_version
    not command -v python > /dev/null 2>&1; or string match -r '\d+.\d+[.\d]*' (command python -V 2>&1)
end

function _go_version
    not command -v go > /dev/null 2>&1; or string match -r '\d+.\d+[.\d]*' (command go version)
end
# language versions }}}

function segment  # {{{
    test -z "$argv"; or printf '%s ' "$argv"
end  # }}}

function fish_prompt --description 'Write out the prompt'
    set -g RC $status
    set -g NJOBS (jobs -c | wc -l)

    not set -q THEME_ENABLE_GLYPHS; or segment (_os_glyph)
    segment (_jobs)
    segment (_path)
    segment (_prompt_end)
end

function fish_right_prompt
    segment (_err_code)
    segment (_git_remote_glyph)
    segment (__fish_git_prompt "%s")

    not set -q THEME_ENABLE_GLYPHS; or _incolor '7FD5EA' ' '
    segment (_incolor brblue (_go_version))

    not set -q THEME_ENABLE_GLYPHS; or _incolor '3E7BAC' ' '
    segment (_incolor blue (_python_version))
    segment (_incolor yellow (_python_venv))

    not set -q THEME_ENABLE_GLYPHS; or _incolor '099CEC' '  '
    segment (_incolor blue (_running_docker_containers))
end
