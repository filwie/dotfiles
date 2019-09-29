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

function _prompt_end  # {{{
    set_color blue
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

function _git_remote_glyph  # {{{
    set -q THEME_ENABLE_GLYPHS; or return
    if command git rev-parse --is-inside-work-tree 2>&1
        switch (command git remote get-url origin)
        case '*github.com*'
            set -g dir_glyph ' '
        case '*gitlab.com*'
            set -g dir_glyph ' '
        case '*bitbucket.com*'
            set -g dir_glyph ' '
        case '*'
            set -g dir_glyph ' '
        end
    end
    printf '%s' $dir_glyph
end  # }}}

# os glyph, os detection {{{
set -g known_oses \
    arch \
    bsd \
    centos \
    fedora \
    mac \
    manjaro \
    opensuse \
    raspbian \
    redhat \
    suse \
    ubuntu

# arch ' '
# bsd ' '
# centos ' '
# fedora ' '
# linux ' '
# mac ' '
# manjaro ' '
# raspbian ' '
# redhat ' '
# suse '  '
# ubuntu ' '

set -g known_oses_glyphs \

set os_regex (printf '%s' (string join '|' $known_oses))

function _distro
    string lower (string match -ir $os_regex (head -n1 /etc/os-release))
end

function _os
    switch (uname)
    case Linux
        string match -i
    case Darwin
        set _os mac
    case '*'
        set _os other
    end
end

function _os_glyph

    set known_glyphs arch bsd linux mac raspbian ubuntu centos redhat
    set unknown_glyph 
    switch (uname)
    case Linux
        set _os (string lower (cat /etc/issue | cut -d' ' -f1))[1]
    case Darwin
        set _os mac
    case '*'
        set _os other
    end
    if string match -q 'glyph' $argv[1]
        if contains $_os $known_glyphs
            printf "%s " $$_os
        else
            printf "%s " $_unknown_glyph
        end
    end
end
# /os glyph, os detection }}}

function _path  # {{{
    if set -q THEME_ENABLE_GLYPHS
        printf '  '
    end
    printf '%s%s%s' (set_color --bold) (prompt_pwd) (set_color normal)
end  # }}}

function _jobs  # {{{
    test $NJOBS -gt 0; or return
    printf '%sj:%s%s' (set_color --bold brblue) $NJOBS (set_color normal)
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
    set -g NJOBS (jobs -c | wc -l | awk '{print $1}')

    segment (_jobs)
    segment (_path)
    segment (_prompt_end)
end

function fish_right_prompt
    segment (_err_code)
    segment (__fish_git_prompt "%s")
    set_color --bold brblue; segment (_go_version)
    set_color --bold blue; segment (_python_version)
    set_color --bold yellow; segment (_python_venv)
    set_color normal
end
