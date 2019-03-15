function __python_venv -d "Return Python virtual environment name if set"
    if not set -q VIRTUAL_ENV; return; end
    printf "%s" (basename (realpath $VIRTUAL_ENV))
end
