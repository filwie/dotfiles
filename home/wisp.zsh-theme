# Resources:
#   http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
BOX_TL="┏"
BOX_BL="┗"
BRANCH_GLYPH=" "
GIT_DIRTY_GLYPH=""
GIT_CLEAN_GLYPH=""
ETH_GLYPH=" "
PYTHON_GLYPH=" "
BANANA_GLYPH=" "
REGULAR_GLYPH=" "
ROOT_GLYPH="  "
ARCH_GLYPH=" "
UBUNTU_GLYPH=" "
APPLE_GLYPH=" "

ZSH_THEME_SCM_PROMPT_PREFIX="${git_info_color}${branch_glyph}${italic}"
ZSH_THEME_GIT_PROMPT_PREFIX="${ZSH_THEME_SCM_PROMPT_PREFIX}"
ZSH_THEME_GIT_PROMPT_SUFFIX="${reset}${space}"

ZSH_THEME_GIT_PROMPT_DIRTY="${warning_color}${space}${git_dirty_glyph}${reset}"
ZSH_THEME_GIT_PROMPT_CLEAN="${ok_color}${space}${git_clean_glyph}${reset}"

function _italic () { echo -n $(tput sitm) }
function _bold () { echo -n $(tput bold) }
function _reset () { echo -n $(tput sgr0) }

function is_remote () {
    # ${REMOTE_CONNECTION} env var is set in zshrc
    # [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]] <- not works in tmux
    [[ "${REMOTE_CONNECTION}" == "true" ]]
}

function is_mac () { [[ "$(uname -a)" =~ ".*Darwin.*" ]] }
function is_linux () { [[ "$(uname)" == "Linux" ]] }
function is_ubuntu () { [[ "$(uname -a)" =~ ".*Ubuntu.*" ]] }
function is_arch () { [[ "$(uname -a)" =~ ".*arch.*" ]] }
function is_docker_container () { [[ -f "/.dockerenv" ]] }

function _os_info () {
    is_arch   && { echo -n "$(tput setaf 4)${ARCH_GLYPH}$(tput sgr0)"; return }
    is_ubuntu && { echo -n "$(tput setaf 3)${UBUNTU_GLYPH}$(tput sgr0)"; return }
    is_mac    && { echo -n "$(tput setaf 7)${APPLE_GLYPH}$(tput sgr0)"; return }
}

function precmd {
    if (( $(id -u) == 0 )); then
        zle_highlight=( default:fg=red,bold )
    else
        zle_highlight=( default:fg=brightwhite )
    fi
}



PATH_SHORT="%2~"
GIT_INFO=$'$(git_prompt_info)$(bzr_prompt_info)'

PROMPT_END_GLYPH="%(!.${root_glyph}.${regular_glyph})"
PROMPT_END="%(?:%{${OK_COLOR}%}${PROMPT_END_GLYPH}:%{${FAIL_COLOR}%}${PROMPT_END_GLYPH})%{$reset_color%}"

#PROMPT="┏ ${os_info} ${path_short} ${git_prompt} $(virtualenv_prompt_info)
#┗ ${ret_status}"

PROMPT='┏ $(_bold) kek $(_reset)$(_italic) fek $(_reset) pek
┗'
RPROMPT='$(tput bold)[%F{yellow}%?%f]$(virtualenv_prompt_info)'

# vim: set filetype=zsh:
