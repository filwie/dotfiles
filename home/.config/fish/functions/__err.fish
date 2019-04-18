function __err -a msg -d "Display error message"
    set_color red
    printf "[ERROR] %s" $msg
    set_color normal
end
