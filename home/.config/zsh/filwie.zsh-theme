# vim: set ft=zsh fdm=marker fmr={{{,}}} fen:

# reference:
#   http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html

# env vars {{{
VIRTUAL_ENV_DISABLE_PROMPT="${VIRTUAL_ENV_DISABLE_PROMPT:-1}"

FILWIE_THEME_SHOW_LANGS="${FILWIE_THEME_SHOW_LANGS:-go python}"
FILWIE_THEME_SHOW_JOBS="${FILWIE_THEME_SHOW_JOBS:-1}"
# /env vars }}}

# font colors and effects {{{
declare -A font fg bg
font=(
    reset      "%{[00m%}"
    +bold      "%{[01m%}"  -bold      "%{[22m%}"
    +italic    "%{[03m%}"  -italic    "%{[23m%}"
    +underline "%{[04m%}"  -underline "%{[24m%}"
)
for color_num in {0..16}; do
    fg[$color_num]="%{[38;5;${color_num}m%}"
    bg[$color_num]="%{[48;5;${color_num}m%}"
done
# /font colros and effects }}}

# path {{{
function _shortpath () {
    if command -v shrink_path &> /dev/null; then shrink_path -f
    else printf '%s' '%2~'; fi
}
function _path () {
    printf '%s%s%s' '%B' "$(_shortpath)" '%b'
}
# /path }}}

# language versions {{{
function _python_venv () { [[ -n "${VIRTUAL_ENV}" ]] && printf "${VIRTUAL_ENV:t}" }
function _python_ver () { printf "${$(python -V 2>&1)#Python *}" }

function python_info () {
    command -v python &> /dev/null || return
    _python_ver
    local venv="$(_python_venv)"
    [[ -n "${venv}" ]] && printf " (%s)" "${venv}"
}

function go_info () {
    command -v go &> /dev/null || return
    printf "${$(go version | awk '{print $3}')#go*}"
}

function node_info () {
    command -v node &> /dev/null || return
    node --version
}

function rust_info () {
    command -v rustc &> /dev/null || return
    rustc --version | awk '{print $2}'
}

function _lang_ver () {
    [[ $1 =~ (go|python|node|rust) ]] || return
    typeset -A lang_color=(
        go      12
        python  4
        node    2
        rust    8
    )
    printf "%s%s%s%s%s" "${fg[${lang_color[${1}]}]}" "${1}:" "${font[+bold]}" "$(${1}_info)" "${font[reset]}"
}

function _langs () {
    for lang in ${(@s/ /)FILWIE_THEME_SHOW_LANGS}; do
        _lang_ver "${lang}"; printf " "
    done
}
# /language versions }}}

# git {{{
# Checks if working tree is dirty
function _is_git_repo () { [[ "$(command git rev-parse --is-inside-work-tree 2>&1)" == "true" ]] }
function _is_git_clean () { test -z "$(git status --porcelain)" }
function _git_branch() {
    local ref ret
    ref=$(command git symbolic-ref --quiet HEAD 2> /dev/null)
    ret=$?
    if [[ $ret != 0 ]]; then
        [[ $ret == 128 ]] && return  # no git repo.
        ref="$(command git rev-parse --short HEAD 2> /dev/null)" || return
    fi
    printf '%s' "${ref#refs/heads/}"
}
function _git () {
    _is_git_repo || return
    local color
    color=2; _is_git_clean || color=3
    printf '%s%s%s' "%F{$color}" "$(_git_branch)" '%f'
}
# /git}}}

local _jobs='%F{12}%B%(1j.j:%j.)%f%b'
local _err_code='%F{1}%B%(?..%?)%f%b'
local _prompt_end='%B%(?.%F{4}.%F{1})%(!.#.>)%f%b'

PROMPT='${_jobs} $(_path) ${_prompt_end} '
RPROMPT='${_err_code} $(_git) $(_langs)'
