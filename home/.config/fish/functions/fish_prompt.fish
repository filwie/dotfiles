set -g prompt_path_properties          '--bold'
set -g prompt_path_color               cyan

set -g prompt_end_properties           '--bold'
set -g prompt_end_color                brblue
set -g prompt_end_color_fail           brred
set -g prompt_char                     '>'
set -g prompt_char_root                '#'

set -g git_info_properties             '--italics'
set -g git_clean_color                 brblack
set -g git_dirty_color                 bryellow

set -g python_version_properties       '--bold'
set -g python_version_color1           brblue
set -g python_version_color2           blue

function git_info -d "Display git branch"
    if not string match -q true (command git rev-parse --is-inside-work-tree 2>&1)
        return
    end
    set git_status (git status --porcelain)
    set git_branch (git branch ^/dev/null | grep \* | sed 's/* //')

    if test -z "$git_status";       set_color $git_clean_color
    else;                           set_color $git_dirty_color
    end
    set_color $git_info_properties
    printf "%s%s " $git_branch (set_color normal)
end

function python_info
    function _version
        if test (command -v python)
            set_color $python_version_properties
            set python_version (string split '' (string match -r '.*(\d\.\d\.(:?\w)+).*' (python -V 2>&1))[2])
            set_color $python_version_color1
            printf "%s" $python_version[1..2]
            set_color $python_version_color2
            printf "%s" $python_version[3..-1]
            set_color normal
        end
    end

    if set -q VIRTUAL_ENV
        set venv (basename $VIRTUAL_ENV)
        set venv_info " ($venv)"
    end

    printf "%s%s%s%s " (_version) (set_color $python_version_color2) $venv_info (set_color normal)
end

function prompt_path -d "Displays shortened path"
    set_color $prompt_path_properties
    set_color $prompt_path_color
    printf "%s%s " (prompt_pwd) (set_color normal)
end

function prompt_end -d "Displays prompt end character based on user (regular or root) and return value"
    set_color $prompt_end_properties
    if test $RETURN_VALUE -eq 0;    set_color $prompt_end_color
    else;                           set_color $prompt_end_color_fail
    end

    if test (id -u) -eq 0;
        set prompt_char $prompt_char_root
    end
    printf "%s%s " $prompt_char (set_color normal)
end


function ascii_prompt
    printf "%s%s%s%s" (prompt_path) (git_info) (python_info) (prompt_end)
end

function fish_prompt
    set -g RETURN_VALUE $status
    
    ascii_prompt
end
