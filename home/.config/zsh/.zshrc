XDG_DATA_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME}/.config}"

ZSH_DATA_HOME="${XDG_DATA_HOME}/zsh"
ZSH_CONFIG_HOME="${XDG_CONFIG_HOME}/zsh"
ZDOTDIR="${ZDOTDIR:-${ZSH_CONFIG_HOME}}"
HISTFILE="${ZSH_DATA_HOME}/zsh_history}"

# zplugin configuration {{{
declare -A ZPLGM
ZPLGM[HOME_DIR]="${ZSH_DATA_HOME}/zplugin_plugins"
ZPLGM[BIN_DIR]="${ZSH_DATA_HOME}/zplugin"

function install_zplugin () {
    local zplugin_repo_url="https://github.com/zdharma/zplugin.git"
    if ! [[ -d "${zplugin_dir}" ]]; then
        mkdir "${zplugin_dir}"
        git clone "${zplugin_repo_url}" "${zplugin_dir}"
    fi
}

[[ -f "${ZPLGM[BIN_DIR]}/zplugin.zsh" ]] || install_zplugin
source "${ZPLGM[BIN_DIR]}/zplugin.zsh"
# /zplugin configuration }}}

# zplugin plugins {{{
zplugin ice silent wait"0" atinit"zpcompinit; zpcdreplay"
zplugin light zsh-users/zsh-autosuggestions
zplugin light zdharma/fast-syntax-highlighting

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zplugin ice silent wait"0" blockf
zplugin light zsh-users/zsh-completions
zplugin ice silent wait"0" atload"_zsh_autosuggest_start"
zplugin light zsh-users/zsh-autosuggestions


zplugin snippet PZT::modules/directory/init.zsh
zplugin snippet OMZ::plugins/git/git.plugin.zsh


# Theme
zplugin light subnixr/minimal

# fzf {{{
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# /fzf }}}

