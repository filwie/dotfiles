function __git_is_clean
    set output (git status --porcelain)
    test -z "$output"
end

