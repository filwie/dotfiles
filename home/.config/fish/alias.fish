# configs
if set -q EDITOR
    set -g _editor $EDITOR
else
    set -g _editor vim
end
alias cfish 'pushd (dirname $FISH_CONF); $_editor $FISH_CONF; popd'
alias cvim 'pushd (dirname $VIM_CONF); $_editor $VIM_CONF; popd'
alias ctmux 'pushd (dirname $TMUX_CONF); $_editor $TMUX_CONF; popd'
alias cemacs 'pushd (dirname $EMACS_CONF); $_editor $EMACS_CONF; popd'

# modified commands
alias ssh 'env TERM=xterm-256color ssh'

# single letter
alias r ranger
alias v vim
alias o open

# Emacs
if command -v emacs > /dev/null && test -f $EMACS_CONF
    alias emacs-server 'emacs --daemon -q -l $EMACS_CONF'
end
alias em 'emacsclient -t -nw -a="emacs -nw"'
alias eg 'emacsclient -c -a=emacs'

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

# Tmux
if set -q TMUX_CONF && test -f $TMUX_CONF
    alias tmux 'tmux -f $TMUX_CONF'
end

# misc
alias cdr 'pushd (git rev-parse --show-toplevel)'
alias unneeded 'echo **/(*.pyc|*.pyo|__pycache__|tags|*.retry)'
