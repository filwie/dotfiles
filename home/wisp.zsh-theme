# vim: set ft=zsh sw=2 ts=2:
# Resources:
#   http://zsh.sourceforge.net/Doc/Release/Expansion.html#Parameter-Expansion
#   http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html

BRANCH_GLYPH=" "
GIT_DIRTY_GLYPH=""
GIT_CLEAN_GLYPH=""
ETH_GLYPH=" "
DIR_GLYPH=" "
PYTHON_GLYPH=" "
BANANA_GLYPH=" "
REGULAR_GLYPH=" "
ROOT_GLYPH="  "
ARCH_GLYPH=" "
UBUNTU_GLYPH=" "
APPLE_GLYPH=" "
RASPBERRY_GLYPH=" "
WHALE_EMOJI="🐳 "

function _italic () { echo -n "%{$(tput sitm)%}" }
function _bold () { echo -n "%{$(tput bold)%}" }
function _reset () { echo -n "%{$(tput sgr0)%}" }
function _fg_color () {
  [[ -n "${1}" ]] && echo -n "%{$(tput setaf ${1})%}"
}

function _reset () { echo -n "%{$(tput sgr0)%}" }

ZSH_THEME_SCM_PROMPT_PREFIX="${BRANCH_GLYPH}$(_italic)"
ZSH_THEME_GIT_PROMPT_PREFIX="${ZSH_THEME_SCM_PROMPT_PREFIX}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$(_reset)"

ZSH_THEME_GIT_PROMPT_CLEAN="$(_fg_color 10) ${GIT_CLEAN_GLYPH}$(_reset)"
ZSH_THEME_GIT_PROMPT_DIRTY="$(_fg_color 9) ${GIT_DIRTY_GLYPH}$(_reset)"

ZSH_THEME_BOX_CHAR=2
ZSH_THEME_ALWAYS_SHOW_PYTHON=1

function is_remote () {
  # ${REMOTE_CONNECTION} env var is set in zshrc
  # [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]] <- not works in tmux
  [[ -n "${REMOTE_CONNECTION}" ]]
}

function _os_info () {
  # below functions' definitions reside in zshrc
  is_arch && { echo -n "$(_fg_color 4)${ARCH_GLYPH}$(_reset)"; return }
  is_ubuntu && { echo -n "$(_fg_color 3)${UBUNTU_GLYPH}$(_reset)"; return }
  is_mac && { echo -n "$(_fg_color 7)${APPLE_GLYPH}$(_reset)"; return }
  is_raspberry && {echo -n "$(_fg_color 9)${RASPBERRY_GLYPH}$(_reset)"; return}
}

function _docker_info () {
  # below function's definition resides in zshrc
  is_docker_container && echo -n "${WHALE_EMOJI}%m"
}

function _python_info () {
  local info="$(_fg_color 3)${PYTHON_GLYPH} $(_fg_color 4)"
  local version="${$(python -V)#Python }"
  if [[ -n ${VIRTUAL_ENV} ]]; then
    info+="${VIRTUAL_ENV:t} (${version})${_reset}"
    echo -n "${info}"
  else
    info+="default (${version})${_reset}"
    [[ ${ZSH_THEME_ALWAYS_SHOW_PYTHON} -eq 1 ]] \
      && echo -n "${info}"
  fi
}

function _ssh_info () {
  is_remote && echo -n "${ETH_GLYPH}SSH"
}

function _path_info () { echo -n "${DIR_GLYPH} %2~" }
function _git_info () { echo -n "$(git_prompt_info)$(bzr_prompt_info)" }

function _segment () {
  local _fg
  [[ -n "${2}" ]] && _fg="$(_fg_color ${2})" || _fg=""
  [[ -n "${1}" ]] && echo -n "${_fg}${1}$(_reset)$(_separator)"
}

function _separator () {
  echo -n " "
}

function _box () {
  local _tl _bl _t _char index
  _t=("─" "━" "═" "─" "═")
  _tl=("╭" "┏" "╔" "╓" "╒")
  _bl=("╰" "┗" "╚" "╙" "╘")
  _index="${2:-1}"
  if [[ "${#}" -gt 1 ]]; then
    case "${1}" in
      t)
        _char="${_t[${_index}]}" ;;
      tl)
        _char="${_tl[${_index}]}" ;;
      bl)
        _char="${_bl[${_index}]}" ;;
      *)
        return ;;
    esac
    echo -n "${_char}"
  fi
}

function _tl () {
  local _s
  _tl=("╭" "┏" "╔" "╓" "╒")
}

function _bl () {
  local _s
  _s=("╰" "┗" "╚" "╙" "╘")
}

function _prompt_end_symbol () {
  local symbol
  if [[ "${UID}" == 0 ]]; then
    symbol="${ROOT_GLYPH}"
  else
    symbol="${REGULAR_GLYPH}"
  fi
  echo -n "${symbol}"
}

function _prompt_end () {
  echo -n "%(?:%{$(_fg_color 15)%}$(_prompt_end_symbol):%{$(_fg_color 1)%}$(_prompt_end_symbol))%{$(_reset)%}"
}

function _prompt () {
  _box t ${ZSH_THEME_BOX_CHAR}
  _separator
  _segment "$(_docker_info)" 4
  _segment "$(_ssh_info)" 3
  _segment "$(_os_info)"
  _box t ${ZSH_THEME_BOX_CHAR}; _separator
  _segment "$(_path_info)" 7
  _segment "$(_git_info)" 11
  _segment "$(_python_info)"
}

function precmd {
  if [[ "${UID}" == 0 ]]; then
    zle_highlight=( default:fg=red,bold )
  else
    zle_highlight=( default:fg=brightwhite )
  fi
}


PROMPT='$(_box tl ${ZSH_THEME_BOX_CHAR})$(_prompt)
$(_box bl ${ZSH_THEME_BOX_CHAR}) $(_prompt_end)'
