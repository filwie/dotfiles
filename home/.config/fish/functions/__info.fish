function __info -a msg -d "Display info message"
    set_color green
    printf "[INFO] %s\n" $msg
    set_color normal
end
