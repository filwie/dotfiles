function __git_is_clean
    test (command git diff-index --quiet HEAD -- 2> /dev/null)
end

