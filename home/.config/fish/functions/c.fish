#!/usr/bin/env fish

if test (__os) = mac
    set -g COMPILE_CMD "gcc-8 -Wall -pedantic -g"
else
    set -g COMPILE_CMD "gcc -Wall -pedantic -g"
end

function _usage
    printf "USAGE: c run/build {SOURCE_FILE} \n"
end

function _build -a source_file -d "Compile source file using GCC"
    __header "compilation"
    eval $COMPILE_CMD $source_file $argv[2..-1]
end

function _run -a binary_executable -d "Run executable binary"
    __header "excution"
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
                if _build $src_file $argv[3..-1]
                    __info "Compilation succeded."
                    __header "execution"
                    ./a.out
                    rm -rf a.out*
                    __info "Removed compiled files."
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
