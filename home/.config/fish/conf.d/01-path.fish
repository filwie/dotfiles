set -l add_to_path_if_exists \
    $PYENV_ROOT/bin \
    $CARGO_HOME/bin \
    $XDG_DATA_HOME/gem/bin \
    $GOPATH/bin \
    $NIM_HOME/bin \
    $NIMBLE_HOME/bin \
    $HOME/bin \
    $HOME/.local/bin \
    $FZF_BASE/bin \
    $XDG_DATA_HOME/npm/bin \
    /usr/local/bin \
    /usr/local/opt/ruby/bin

if command -v brew > /dev/null 2>&1
    set --prepend PATH (brew --prefix)/bin
end

switch (uname)
case Darwin
    set --append PATH $HOME/Library/Python/**/bin/
end

for bin_dir in $add_to_path_if_exists
    if test -d $bin_dir; and not contains $bin_dir $PATH
        set --prepend PATH $bin_dir
    end
end

if command -v pyenv > /dev/null 2>&1
    command pyenv init - | source
end
