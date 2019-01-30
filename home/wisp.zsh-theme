# TEXT STYLE {{{
italic="$(tput sitm)"
bold="$(tput bold)"
reset="$(tput sgr0)"
# }}}

# COLORS {{{
git_info_color="%{${fg[brightwhite]}%}"
path_color="%{${fg[white]}%}"
distinct_color="%{${fg[brightorange]}%}"
ok_color="${fg[green]}"
warning_color="%{${fg[yellow]}%}"
critical_color="%{${fg[red]}%}"
indicator_color="%{${fg[blue]}%}"
# }}}

# CHARACTERS {{{
space=" "

# os
docker_info=""
os_info=""

is_docker_container && docker_info="$(tput setaf 4)🐳 (${HOSTNAME})$(tput sgr0)"
is_arch && os_info="$(tput setaf 4) $(tput sgr0)"
is_ubuntu && os_info="$(tput setaf 3) $(tput sgr0)"
is_mac && os_info="$(tput setaf 15) $(tput sgr0)"

# glyphs
local branch_glyph=" "
local git_dirty_glyph=""
local git_clean_glyph=""
local eth_glyph=" "
local python_glyph=" "
local banana_glyph=" "
# prompt
local regular_glyph=" "
local root_glyph="  "
# }}}

# FUNCTIONS {{{
function is_remote () {
    # ${REMOTE_CONNECTION} env var is set in zshrc
    # simple check like commented out did not work in tmux
    # [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]
    [[ "${REMOTE_CONNECTION}" == "true" ]]
}

function is_mac () {
    [[ "$(uname -a)" =~ ".*Darwin.*" ]]
}

function is_linux () {
    [[ "$(uname)" == "Linux" ]]
}

function is_ubuntu () {
    [[ "$(uname -a)" =~ ".*Ubuntu.*" ]]
}

function is_arch () {
    [[ "$(uname -a)" =~ ".*arch.*" ]]
}

function is_docker_container () {
    [[ -f "/.dockerenv" ]]
}

# Root types in bold red
function precmd {
    if (( $(id -u) == 0 )); then
        zle_highlight=( default:fg=red,bold )
    else
        zle_highlight=( default:fg=brightwhite )
    fi
}
# }}}

ZSH_THEME_SCM_PROMPT_PREFIX="${git_info_color}${branch_glyph}${italic}"
ZSH_THEME_GIT_PROMPT_PREFIX="${ZSH_THEME_SCM_PROMPT_PREFIX}"
ZSH_THEME_GIT_PROMPT_SUFFIX="${reset}${space}"

ZSH_THEME_GIT_PROMPT_DIRTY="${warning_color}${space}${git_dirty_glyph}${reset}"
ZSH_THEME_GIT_PROMPT_CLEAN="${ok_color}${space}${git_clean_glyph}${reset}"

local path_short="${path_color}%2~${reset}${space}"
local git_prompt=$'$(git_prompt_info)$(bzr_prompt_info)'

local prompt_end="%(!.${root_glyph}.${regular_glyph})"

local ret_status="%(?:%{${path_color}%}${prompt_end}:%{${critical_color}%}${prompt_end})%{$reset_color%}"

PROMPT="┏ ${os_info} ${path_short} ${git_prompt} $(virtualenv_prompt_info)
┗ ${ret_status}"
RPROMPT='[%F{yellow}%?%f]$(virtualenv_prompt_info)'

# vim: set filetype=zsh:
