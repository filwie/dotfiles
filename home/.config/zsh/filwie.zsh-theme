local ret_code="%?"
local path_short="%2~"

# local prompt_end="%(!.${prompt_end[root]}.${prompt_end[user]})"

local function __path () {
    if command -v shrink_path &> /dev/null; then shrink_path -f
    else printf "%s" "%2~"; fi
}

local function __python () {
    command -v python &> /dev/null || return
    local python_ver="$(python -V 2>&1)"
    printf "%s" "${python_ver#Python *}"
}

local function __go () {
    command -v go &> /dev/null || return
    local go_ver="$(go version | awk '{print $3}')"
    printf "%s" "${go_ver#go*}"
}

PROMPT="$(__path) $(__python) $(__go)"
RPROMPT='$(date +%T)'

# vim: set filetype=zsh:
