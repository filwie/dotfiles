set _path $HOME/.local/bin $HOME/bin

# MacOS
if string match -q 'Darwin' (uname)
    set _path $_path $HOME/Library/Python/**/bin/
end

# FZF
set _fzf_bin $FZF_BASE/bin
if test -d $_fzf_bin
    set _path $_path $_fzf_bin
end

# Go
set _go /usr/local/go/bin/go
if test -x $_go
    set _path $_path ($_go env GOPATH)/bin
    set -x GOPATH ($_go env GOPATH)
end

# Rust
set _cargo_bin $HOME/.cargo/bin
if test -d $_cargo_bin
    set _path $_path $_cargo_bin
end

set -gx fish_user_paths $_path
