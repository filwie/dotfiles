function _usage
    set _u 'USAGE: gitignore [-h/--help] [-f/--file FILE] [-g/--git] {LANGUAGE/OS/EDITOR}'
    set _h '  -h/--help    display help'
    set _f '  -f/--file    output to specified FILE'
    set _g '  -g/--git     output to .gitignore file in git repository root'
    set _e 'EXAMPLE: gitignore -g python vim'
    printf "\n%s\n\n%s\n%s\n%s\n\n%s\n\n" $_u $_h $_f $_g $_e
end

function gitignore -d 'Create gitignore file '
    argparse --name=gitignore 'h/help' 'f/file=' 'g/git' -- $argv
    if set -q _flag_help || test (count $argv) -lt 1
        _usage
        return
    end
    for arg in $argv
        if set -q _flag_file
            set output (realpath $_flag_file)
        else if set -q _flag_git && string match -q true (command git rev-parse --is-inside-work-tree 2>&1)
            set output (realpath (git rev-parse --show-toplevel)/.gitignore)
        else
            set output /dev/stdout
        end
        curl -sL https://www.gitignore.io/api/$arg >> $output
    end
end
