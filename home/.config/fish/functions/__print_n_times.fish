function __print_n_times -a n pattern -d "Print pattern N times"
    for i in (seq $n)
        printf "%s" $pattern
    end
end
