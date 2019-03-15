function _usage
    printf "USAGE: new function {{ function_name }}\n"
end

function _init_function
    echo -n"function $argv[1]\n\nend" >> $argv[2]
end

function new
    if test (count $argv) -ne 2
        _usage
        return 1
    end

    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME $HOME/.config
    set fish_functions_dir $XDG_CONFIG_HOME/fish/functions/

    switch $argv[1]
    case function
        set function_name $argv[2]
        set function_path $fish_functions_dir/$function_name.fish
        if test -f $function_path
            echo File already exists!
            return 1
        end
    case '*'
    end
end
