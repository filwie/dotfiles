# vim: set ft=zsh:
VIRTUAL_ENV_DISABLE_PROMPT="${VIRTUAL_ENV_DISABLE_PROMPT:-1}"

FILWIE_THEME_ENABLE_NERD="${FILWIE_THEME_ENABLE_NERD:-0}"
FILWIE_THEME_ENABLE_EMOJI="${FILWIE_THEME_ENABLE_EMOJI:-0}"

local ret_code="%?"
local path_short="%2~"

# glyphs, emojis {{{

declare -A glyphs emojis

glyphs=(
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

no_glyphs=(
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

emojis=(
    whale "🐳"
)
# /glyphs, emojis }}}

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

function _path () {  # {{{
    if command -v shrink_path &> /dev/null; then shrink_path -f
    else printf "%s" "%2~"; fi
}  # }}}

function _is_git_repo () { [[ "$(git rev-parse --is-inside-work-tree 2>&1)" == "true" ]] }

# _lang_ver helpers {{{
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
# /lang_ver helpers }}}

function _lang_ver () {  # {{{
    [[ $1 =~ (go|python|node|rust) ]] || return
    declare -A lang_color
    lang_color=(
        go      12
        python  4
        node    2
        rust    8
    )
    printf "%s%s%s%s%s" "${fg[${lang_color[${1}]}]}" "${1}:" "${font[+bold]}" "$(${1}_info)" "${font[reset]}"
}  # }}}

function prompt_end () {  # {{{
    declare -A _end_root _end_user
    _end_root=(
        0 no_glyphs[root]
        1 glyphs[root]
    )
    _end_user=(
        0 no_glyphs[user]
        1 glyphs[user]
    )

    local _end_color=11; test "${ret_code}" -eq 0 || _end_color=1
    local _prompt_no_glyph="${}"

    local _prompt_end="%(!.${_prompt})"
}  # }}}

PROMPT='$(_path) %(!.${_prompt_root}.${_prompt_user}) '
RPROMPT='$(_lang_ver go) $(_lang_ver python)'
