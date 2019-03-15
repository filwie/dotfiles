# configs
alias cfish 'pushd (dirname $FISH_CONF); vim $FISH_CONF; popd'
alias cvim 'pushd (dirname $VIM_CONF); vim $VIM_CONF; popd'
alias ctmux 'pushd (dirname $TMUX_CONF); vim $TMUX_CONF; popd'
alias cemacs 'pushd (dirname $EMACS_CONF); vim $EMACS_CONF; popd'

# modified commands
alias ssh 'env TERM=xterm-256color ssh'

# single letter
alias r ranger
alias v vim
alias o open
alias e emacs

# Vim
alias :e vim
alias :q exit
if command -v nvim > /dev/null
    alias vim nvim
else if command -v gvim > /dev/null
    alias vim 'gvim -v'
else if command -v mvim > /dev/null
    alias vim 'mvim -v'
end

# Emacs
if command -v emacs > /dev/null && test -f $EMACS_CONF
    alias emacs 'env TERM=xterm-24bit emacs --no-window-system -q -l $EMACS_CONF'
end

if command -v open > /dev/null
    alias :o open
end

# Tmux
if set -q $TMUX_CONF && test -f $TMUX_CONF
    alias tmux 'tmux -f $TMUX_CONF'
end

# misc
alias cdr 'pushd (git rev-parse --show-toplevel)'
alias unneeded 'echo **/(*.pyc|*.pyo|__pycache__|tags|*.retry)'
