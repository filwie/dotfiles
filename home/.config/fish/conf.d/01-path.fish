set -l add_to_path_if_exists \
    $HOME/bin \
    $HOME/.local/bin \
    $FZF_BASE/bin \
    $GOPATH/bin \
    $CARGO_HOME/bin \
    $NIM_HOME/bin \
    $NIMBLE_HOME/bin \
    /usr/local/bin

switch (uname)
case Darwin
    set --prepend PATH $HOME/Library/Python/**/bin/
end

for bin_dir in $add_to_path_if_exists
    if test -d $bin_dir; and not contains $bin_dir $PATH
        echo $PATH | sed 's/ /\n/g'
        set --prepend PATH $bin_dir
        echo $PATH | sed 's/ /\n/g'
    end
end