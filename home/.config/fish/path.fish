set -l add_to_path_if_exists \
    /usr/local/bin \
    $HOME/bin \
    $HOME/.local/bin \
    $FZF_BASE/bin \
    $HOME/.cargo/bin

switch (uname)
case Darwin
    set --append PATH $HOME/Library/Python/**/bin/
end

for bin_dir in $add_to_path_if_exists
    if test -d $bin_dir && not contains $bin_dir $PATH
        set --append PATH $bin_dir
    end
end
