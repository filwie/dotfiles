function __python_version
    if test (command -v python)
        printf "%s" (string match -r '.*(\d\.\d\.(:?\w)+).*' (python -V 2>&1))[2]
    end
end
