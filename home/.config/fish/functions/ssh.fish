function ssh
    if command -v kitty > /dev/null
        kitty kitten ssh $argv
    else
        env TERM=screen-256color ssh $argv
    end
end
