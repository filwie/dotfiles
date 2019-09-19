autoload -Uz compinit
compinit

# env {{{
export TMUX_ALWAYS=0
export VIRTUAL_ENV_DISABLE_PROMPT 0

export XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"

export EDITOR=nvim
export VIM_SHELL="$(command -v zsh)"
export TMUX_SHELL="$(command -v zsh)"

export ZSH_DATA_HOME="${XDG_DATA_HOME}/zsh"
export ZSH_CONFIG_HOME="${XDG_CONFIG_HOME}/zsh"
export ZDOTDIR="${ZDOTDIR:-${ZSH_CONFIG_HOME}}"
export ZSHRC="${ZDOTDIR}/.zshrc"
# /env }}}

# path {{{

path_candidates=("${HOME}/.local/bin"
                 "${HOME}/bin"
                 "${CARGO_HOME}/bin"
                 "${GOROOT}/bin"
                 "${GOPATH}/bin"
                 "${JAVA_BIN}")

for path_candidate in "${path_candidates[@]}"; do
    [[ -d "${path_candidate}" ]] && path+=("${path_candidate}")
done

# /path }}}

# aliases {{{
alias ssh='env TERM=xterm-256color ssh'

command -v nvim &> /dev/null && alias vim=nvim
alias e="$EDITOR"
alias r=ranger
alias l=ls
alias ll='ls -la'

if [[ "$(uname)" == "Linux" ]]; then
    alias o=xdg-open
    alias ls='ls --color=auto'
else
    alias ls='ls -G'
fi
# /aliases }}}

# functions {{{
function gitr () {git rev-parse --show-toplevel}
function cdr () {pushd $(git rev-parse --show-toplevel)}
function start_attach_tmux () {
    command -v tmux &> /dev/null || return
    if [[ -z "${TMUX}" ]]; then
        local session_id="$(tmux ls 2>&1 | grep -vm1 attached | cut -d: -f1)"
        if [[ -z "${session_id}" ]]; then tmux new-session
        else tmux attach-session -t "${session_id}"
        fi
    fi
}
# /functions }}}

# history {{{
HISTFILE="${ZSH_DATA_HOME}/zsh_history"
HISTSIZE=100000000
SAVEHIST=100000000
setopt appendhistory inc_append_history
setopt append_history extended_history
setopt hist_expire_dups_first hist_ignore_dups
setopt hist_verify
setopt share_history
# /history }}}

# zsh config {{{
setopt autocd beep extendedglob nomatch notify
setopt autopushd pushdminus pushdsilent pushdtohome pushdignoredups
unsetopt correct_all
setopt multios
setopt cdablevars
setopt prompt_subst
setopt auto_menu
setopt complete_in_word
setopt completealiases
setopt always_to_end

zstyle ':completion:*' menu select
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
# /zsh config }}}

# keyboard {{{
bindkey "$terminfo[kRIT5]" forward-word
bindkey "$terminfo[kLFT5]" backward-word
# }}}

# zplugin config {{{
declare -A ZPLGM
ZPLGM[HOME_DIR]="${ZSH_DATA_HOME}/zplugin_plugins"
ZPLGM[BIN_DIR]="${ZSH_DATA_HOME}/zplugin"

function install_zplugin () {
    local zplugin_repo_url="https://github.com/zdharma/zplugin.git"
    if ! [[ -d "${ZPLGM[BIN_DIR]}" ]]; then
        mkdir -p "${ZPLGM[BIN_DIR]}"
        git clone "${zplugin_repo_url}" "${ZPLGM[BIN_DIR]}"
    fi
}

[[ -f "${ZPLGM[BIN_DIR]}/zplugin.zsh" ]] || install_zplugin
source "${ZPLGM[BIN_DIR]}/zplugin.zsh"
# /zplugin config }}}

# zplugin plugins {{{
zplugin ice silent wait"0" atinit"zpcompinit; zpcdreplay"
zplugin light zsh-users/zsh-autosuggestions
zplugin light zdharma/fast-syntax-highlighting

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zplugin ice silent wait"0" blockf
zplugin light zsh-users/zsh-completions
zplugin ice silent wait"0" atload"_zsh_autosuggest_start"
zplugin light zsh-users/zsh-autosuggestions
zplugin light hlissner/zsh-autopair

zplugin snippet OMZ::plugins/shrink-path/shrink-path.plugin.zsh
zplugin snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh

# zplugin snippet OMZ::plugins/git/git.plugin.zsh
# zplugin ice svn; zplugin snippet PZT::modules/git
# zplugin snippet OMZ::plugins/git/git.plugin.zsh
# zplugin snippet PZT::modules/helper/init.zsh
zplugin ice as"completion"
zplugin snippet https://git.kernel.org/pub/scm/git/git.git/plain/contrib/completion/git-completion.zsh
# /zplugin plugins }}}

# completions {{{
source <(kubectl completion zsh)
# /completions }}}

# theming {{{
[[ -f "${ZDOTDIR}/filwie.zsh-theme" ]] && source "${ZDOTDIR}/filwie.zsh-theme"
# /theming }}}

# fzf {{{
fzf_candidates=("${XDG_DATA_HOME}/fzf" "${XDG_CONFIG_HOME}/fzf" "${HOME}/.fzf" "/usr/share/fzf" "/usr/local/opt/fzf")
for fzf_candidate in "${fzf_candidates[@]}"; do
    if [[ -d "${fzf_candidate}" ]]; then
        [[ -d "${fzf_candidate}/bin" ]] && path+=("${fzf_candidate}/bin")
        if ! [[ -f "${fzf_candidate}/fzf.zsh" ]]; then
            "${fzf_candidate}/install" --xdg --all --no-bash --no-fish --no-update-rc
        fi
        source ${fzf_candidate}/fzf.zsh
        export FZF_BASE="${fzf_candidate}"
        break
    fi
done
# /fzf }}}

if [[ "${TMUX_ALWAYS}" == 1 ]]; then
    start_attach_tmux
fi
