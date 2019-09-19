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
for color_num in {0..255}; do
    fg[$color_num]="%{[38;5;${color_num}m%}"
    bg[$color_num]="%{[48;5;${color_num}m%}"
done
# /font colros and effects }}}

# path {{{
function __filwie_shortpath () {
    if command -v shrink_path &> /dev/null; then shrink_path -f
    else printf '%s' '%2~'; fi
}
function __filwie_path () {
    printf '%s%s%s' '%B' "$(__filwie_shortpath)" '%b'
}
# /path }}}

# language versions {{{
function __filwie_python_venv () { [[ -n "${VIRTUAL_ENV}" ]] && printf "${VIRTUAL_ENV:t}" }
function __filwie_python_ver () { printf "${$(python -V 2>&1)#Python *}" }

function __filwie_python_info () {
    command -v python &> /dev/null || return
    __filwie_python_ver
    local venv="$(__filwie_python_venv)"
    [[ -n "${venv}" ]] && printf " (%s)" "${venv}"
}

function __filwie_go_info () {
    command -v go &> /dev/null || return
    printf "${$(go version | awk '{print $3}')#go*}"
}

function __filwie_node_info () {
    command -v node &> /dev/null || return
    node --version
}

function __filwie_rust_info () {
    command -v rustc &> /dev/null || return
    rustc --version | awk '{print $2}'
}

function __filwie_ansible_info () {
    # this one is really slow
    command -v ansible &> /dev/null || return
    printf "${$(ansible --version | head -n1)#ansible *}"
}

function __filwie_lang_ver () {
    [[ $1 =~ (ansible|go|python|node|rust) ]] || return
    typeset -A lang_color=(
        ansible 15
        go      12
        python  4
        node    2
        rust    8
    )
    printf "%s%s%s%s%s" "${fg[${lang_color[${1}]}]}" "${1}:" "${font[+bold]}" "$(__filwie_${1}_info)" "${font[reset]}"
}

function __filwie_langs () {
    for lang in ${(@s/ /)FILWIE_THEME_SHOW_LANGS}; do
        __filwie_lang_ver "${lang}"; printf " "
    done
}
# /language versions }}}

local _jobs='%F{12}%B%(1j.j:%j.)%f%b'
local _err_code='%F{1}%B%(?..%?)%f%b'
local _prompt_end='%B%(?.%F{4}.%F{1})%(!.#.>)%f%b'

# setopt PROMPT_SUBST
PROMPT='${_jobs} $(__filwie_path) ${_prompt_end} '
RPROMPT='${_err_code} $(__filwie_langs)'
