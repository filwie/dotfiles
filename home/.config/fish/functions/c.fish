#!/usr/bin/env fish

set -g COMPILE_CMD "gcc -Wall -pedantic -g"

function _usage
    printf "USAGE: c run/build SOURCE_FILE \n"
end

function _info -a msg -d "Display info message"
    set_color green
    printf "[INFO] %s\n" $msg
    set_color normal
end

function _err -a msg -d "Display error message"
    set_color red
    printf "[ERROR] %s" $msg
    set_color normal
end

function _print_n_times -a n pattern -d "Print pattern N times"
    for i in (seq $n)
        printf "%s" $pattern
    end
end

function _header -a text -d "Display text formatted as header"
    set header_len 60
    set header_text_len (string length $text)

    set separator "-"
    set separator_len (math -s0 (math $header_len - $header_text_len) / 2)

    printf "\n%s" (_print_n_times $separator_len $separator)
    set_color --bold
    printf " %s " (string upper $text)
    set_color normal
    printf "%s\n" (_print_n_times $separator_len $separator)
    printf "\n"
end

function _build -a source_file -d "Compile source file using GCC"
    _header "compilation"
    eval $COMPILE_CMD $source_file
end

function _run -a binary_executable -d "Run executable binary"
    _header "excution"
    $binary_executable
end


function c -a cmd src_file -d "Compile and run single file C program"
    if test -z $cmd || test -z $src_file
        _usage
        return 1
    end
    switch $cmd
        case run
            begin
                if _build $src_file
                    _info "Compilation succeded."
                    _header "execution"
                    ./a.out
                    rm -rf a.out*
                    _info "Removed compiled files."
                else
                    _err "Compilation failed."
                end
            end
        case help
            _usage
        case '*'
            _usage
    end
end
