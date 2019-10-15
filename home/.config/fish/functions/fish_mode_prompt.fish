function fish_mode_prompt
    set_color --bold black
    switch $fish_bind_mode
    case default
        set_color -b brblack
        printf ' N '
    case insert
        set_color -b brblue
        printf ' I '
    case replace_one
        set_color brgreen
        printf ' R '
    case visual
        set_color -b bryellow
        printf ' V '
    end
    set_color normal; printf ' '
end
