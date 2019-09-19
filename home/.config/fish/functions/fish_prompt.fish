# vars {{{
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

set __fish_git_prompt_show_informative_status
set __fish_git_prompt_showcolorhints
set __fish_git_prompt_showupstream 'auto'
# /vars }}}

function _prompt_end  # {{{
    set_color blue
    test $RC -eq 0; or set_color red
    printf '%s%s%s' (set_color --bold) ">" (set_color normal)
end  # }}}

function _err_code  # {{{
    if test $RC -gt 0
        printf '%s%s%s' (set_color --bold red) $RC (set_color normal)
    end
end  # }}}

function _path  # {{{
    printf '%s%s%s' (set_color --bold) (prompt_pwd) (set_color normal)
end  # }}}

function _jobs  # {{{
    test $NJOBS -gt 0; or return
    printf '%sj:%s%s' (set_color --bold brblue) $NJOBS (set_color normal)
end  # }}}

function segment  # {{{
    test -z "$argv"; or printf '%s ' "$argv"
end  # }}}

function fish_prompt --description 'Write out the prompt'
    set -g RC $status
    set -g NJOBS (jobs -c | wc -l)

    segment (_jobs)
    segment (_path)
    segment (_prompt_end)
end

function fish_right_prompt
    segment (_err_code)
    segment (__fish_git_prompt "%s")
end
