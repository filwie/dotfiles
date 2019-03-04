function __git_branch -d 'Return git branch if in repository'
    if not __git_is_repo; return; end

    set _output (command git status | head -n 1)

    if string match -qr '^HEAD detached.*' $_output
        set _branch (string replace 'HEAD detached at' '' $_output)
    else
       set _branch (string replace 'On branch ' '' $_output)
    end

    printf "%s" $_branch
end
