# Escape codes
local start_italics=$'%{\x1b[3m%}'
local end_italics=$'%{\x1b[0m%}'

# Colors
local git_info_color="%{${fg[brightwhite]}%}"
local path_color="%{${fg[white]}%}"
local distinct_color="%{${fg[brightorange]}%}"
local warning_color="%{${fg[yellow]}%}"
local critical_color="%{${fg[red]}%}"
local indicator_color="%{${fg[blue]}%}"

ZSH_THEME_SCM_PROMPT_PREFIX="${git_info_color} ${start_italics}"
ZSH_THEME_GIT_PROMPT_PREFIX="${ZSH_THEME_SCM_PROMPT_PREFIX}"
ZSH_THEME_GIT_PROMPT_SUFFIX="${end_italics} "

ZSH_THEME_GIT_PROMPT_DIRTY="${warning_color}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="✔%{$reset_color%}"

local path_short="${path_color}%2~%{${reset_color}%} "
local git_prompt=$'$(git_prompt_info)$(bzr_prompt_info)'

# Root types in bold red
function precmd {
    if (( $(id -u) == 0 )); then
        zle_highlight=( default:fg=red,bold )
    else
        zle_highlight=( default:fg=brightwhite )
    fi
}

local regular_glyph=""
local root_glyph=" "
local glyph="%(!.${root_glyph}.${regular_glyph})"

local ret_status="%(?:%{${path_color}%}${glyph}:%{${critical_color}%}${glyph})%{$reset_color%} "

PROMPT="${path_short}${git_prompt}${ret_status}"

GIT_CB="git::"

# vim: set filetype=zsh:
