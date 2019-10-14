function fish_mode_prompt
    switch $fish_bind_mode
    case default
        set_color -b brblack
        set_color --bold black
        echo ' N '
    case insert
        set_color -b brblue
        set_color --bold black
        echo ' I '
    case replace_one
        set_color brgreen
        echo ' R '
    case visual
        set_color -b bryellow
        set_color --bold black
        echo ' V '
    end
    set_color normal
end
