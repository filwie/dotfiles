abbr --add --global  gitr 'printf (git rev-parse --show-toplevel)'
abbr --add --global  cdr 'pushd (git rev-parse --show-toplevel)'

if command -v exa > /dev/null
    abbr --add --global  ls 'exa'
end

abbr --add --global :q 'exit'
abbr --add --global :e 'vim'
abbr --add --global e 'vim'

abbr --add --global code 'env THEME_ENABLE_GLYPHS="" code'
