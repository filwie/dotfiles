function __git_is_repo -d 'Check if in git repo'
    string match -q true (command git rev-parse --is-inside-work-tree 2>&1)
end
