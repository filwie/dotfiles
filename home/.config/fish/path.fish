set -l add_to_path_if_exists \
    /usr/local/bin \
    $HOME/bin \
    $HOME/.local/bin \
    $FZF_BASE/bin \
    $HOME/.cargo/bin

switch (uname)
case Darwin
    set -Ux fish_user_paths $HOME/Library/Python/**/bin/ $fish_user_paths
end

for bin_dir in $add_to_path_if_exists
    if test -d
        set -Ux fish_user_paths $bin_dir $fish_user_paths
    end
end
