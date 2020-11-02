function ssh
    if command -v kitty > /dev/null
        env TERM=screen-256color ssh $argv
    else
        kitty kitten ssh $argv
    end
end
