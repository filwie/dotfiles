# configs
alias cfish 'pushd (dirname $FISH_CONF); vim $FISH_CONF; popd'
alias cvim 'pushd (dirname $VIM_CONF); vim $VIM_CONF; popd'
alias ctmux 'pushd (dirname $TMUX_CONF); vim $TMUX_CONF; popd'

# modified commands
alias ssh 'env TERM=xterm-256color ssh'

# single letter
alias r ranger

# Vim
alias :e vim
if command -v nvim > /dev/null
    alias vim nvim
else if command -v gvim > /dev/null
    alias vim 'gvim -v'
else if command -v mvim > /dev/null
    alias vim 'mvim -v'
end

if command -v open > /dev/null
    alias :o open
end

# Tmux
if set -q $TMUX_CONF || test -f $TMUX_CONF
    alias tmux 'tmux -f $TMUX_CONF'
end

# misc
alias cdr 'pushd (git rev-parse --show-toplevel)'
alias unneeded 'echo **/(*.pyc|*.pyo|__pycache__|tags|*.retry)'
