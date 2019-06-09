set _path $HOME/.local/bin $HOME/bin /usr/local/sbin

# Java
if set -q JAVA_BIN
    set _path $_path $JAVA_BIN
end

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
if command -v go >> /dev/null
    set _go (command -v go)
else if test -x /usr/local/go/bin/go
    set _go /usr/local/go/bin/go
end
if set -q _go
    set -gx GOPATH ($_go env GOPATH)
    if test (__os) = "mac"
        set -gx GOROOT /usr/local/opt/go/libexec
    else
        set -gx GOROOT (dirname (dirname $_go))
    end
    set _path $_path $GOPATH/bin $GOROOT/bin
end

# Rust
set _cargo_bin $HOME/.cargo/bin
if test -d $_cargo_bin
    set _path $_path $_cargo_bin
end

set -gx fish_user_paths $_path
