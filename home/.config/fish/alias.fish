# modified commands
alias ssh 'env TERM=xterm-256color ssh'

# single letter
alias r ranger
alias e $EDITOR
alias o xdg-open

# vim-like
alias vim $EDITOR
alias :e $EDITOR
alias :q exit

# Mac OS
command -v gwc > /dev/null  && alias wc='gwc'
command -v gsed > /dev/null && alias sed='gsed'

# misc
alias gitr 'printf (git rev-parse --show-toplevel)'
alias cdr 'pushd (git rev-parse --show-toplevel)'
