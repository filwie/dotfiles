# vim: set ft=zsh fdm=marker fmr={{{,}}} fen:

# reference:
#   http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html

# env vars {{{
VIRTUAL_ENV_DISABLE_PROMPT="${VIRTUAL_ENV_DISABLE_PROMPT:-1}"

FILWIE_THEME_ENABLE_NERD="${FILWIE_THEME_ENABLE_NERD:-0}"
FILWIE_THEME_ENABLE_EMOJI="${FILWIE_THEME_ENABLE_EMOJI:-0}"
FILWIE_THEME_SHOW_LANGS="${FILWIE_THEME_SHOW_LANGS:-go python}"
FILWIE_THEME_SHOW_JOBS="${FILWIE_THEME_SHOW_JOBS:-1}"

[[ "${FILWIE_THEME_ENABLE_NERD}" =~ '0|1' ]] || FILWIE_THEME_ENABLE_NERD=0
[[ "${FILWIE_THEME_ENABLE_EMOJI}" =~ '0|1' ]] || FILWIE_THEME_ENABLE_EMOJI=0
# /env vars }}}

local return_code="%?"
local jobs_number="%j"

# glyphs {{{
typeset -A glyphs=(
    branch    " "
    git_dirty ""
    git_clean ""
    eth       " "
    dir       " "
    python    " "
    banana    " "
    root      " "
    user      ""
    arch      " "
    ubuntu    " "
    apple     " "
    raspberry " "
)
# /glyphs }}}

# ascii, unicode {{{
typeset -A no_glyphs=(
    branch    ""
    git_dirty ""
    git_clean ""
    eth       ""
    dir       ""
    python    ""
    banana    ""
    root      "#"
    user      "$"
    arch      ""
    ubuntu    ""
    apple     ""
    raspberry ""
)
# /ascii, unicode }}}

# emojis {{{
 typeset -A emojis=(
    whale       "🐳"
    plus        "➕"
    minus       "➖"
    radiocative "☢️"
    biohazard   "☣️ "
    tick        "✔️"
    cross       "❌"
)
# /emojis }}}

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
    else printf "%s" "%2~"; fi
}

function _path () {
    printf "%s%s%s" \
        "${font[+bold]}" \
        "$(_shortpath)" \
        "${font[reset]}"
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
    declare -A lang_color
    lang_color=(
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
function _is_git_repo () { [[ "$(git rev-parse --is-inside-work-tree 2>&1)" == "true" ]] }
function _is_git_clean () { test -z "$(git status --porcelain)" }
function _git_branch () {
    local branch
    branch="${$(git symbolic-ref HEAD 2>/dev/null)##refs/heads/}" ||
        branch="${$(git status | head -n 1)##HEAD detached at }"
    printf "%s" "${branch}"
}
function _git () {
    _is_git_repo || return
    local color
    color="${fg[2]}"; _is_git_clean || color="${fg[3]}"
    printf "%s%s%s%s" \
        "${font[+bold]}" \
        "${color}" \
        "$(_git_branch)" \
        "${font[reset]}"
}
# /git}}}

# error code {{{
function _err_code () {
    printf "%s" "${font[+bold]}${fg[1]}${return_code}${font[reset]}"
}
# /error code }}}

# jobs {{{
function _jobs () {
    [[ "${FILWIE_THEME_SHOW_JOBS}" == 1 ]] || return
    printf "%s" "${font[+bold]}${fg[12]}j:${jobs_number}${font[reset]}"
}
# /jobs }}}

function _prompt_end () {  # {{{
    local _end_color="%(?.${fg[4]}.${fg[1]})"
    typeset -A _end_char_user=(
        0 ">"
        1 "${glyphs[user]}"
    )
    typeset -A _end_char_root=(
        0 "#"
        1 "${glyphs[root]}"
    )
    typeset -A _end_char=(
        user "${_end_char_user[${FILWIE_THEME_ENABLE_NERD}]}"
        root "${_end_char_root[${FILWIE_THEME_ENABLE_NERD}]}"
    )
    printf "%s%s%s%s" \
        "${_end_color}" \
        "${font[+bold]}" \
        "%(!.${_end_char[root]}.${_end_char[user]})" \
        "${font[reset]}"
}  # }}}

PROMPT='%(1j.$(_jobs) .)$(_path) $(_prompt_end) '
RPROMPT='%(?..$(_err_code)) $(_git) $(_langs)'
