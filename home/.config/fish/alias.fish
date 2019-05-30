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

# Microk8s
if command -v microk8s.kubectl > /dev/null && not command -v kubectl > /dev/null
    # autocompletion: https://github.com/evanlucas/fish-kubectl-completions/issues
    # %s/\skubectl/\ microk8s.kubectl\ /g
    alias kubectl 'microk8s.kubectl'
end

# misc
alias gitr 'printf (git rev-parse --show-toplevel)'
