function gitignore
    #TODO: loop over positional arguments + add -f argument
    curl -sL https://www.gitignore.io/api/\$argv[1]
end
