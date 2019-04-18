function __header -a text -d "Display text formatted as header"
    set header_len 60
    set header_text_len (string length $text)

    set separator "-"
    set separator_len (math -s0 (math $header_len - $header_text_len) / 2)

    printf "\n%s" (__print_n_times $separator_len $separator)
    set_color --bold
    printf " %s " (string upper $text)
    set_color normal
    printf "%s\n" (__print_n_times $separator_len $separator)
    printf "\n"
end
