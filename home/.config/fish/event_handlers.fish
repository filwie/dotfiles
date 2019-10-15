function _set_git_remote_glyph --on-variable PWD
    set -q THEME_ENABLE_GLYPHS; or return
    command -v git > /dev/null; or return
    if command git rev-parse --is-inside-work-tree > /dev/null 2>&1
        switch (command git remote get-url origin 2> /dev/null; or echo)
        case '*github.com*'
            set -gx _git_dir_glyph ' '
            set -gx _git_dir_color FFFFFF
        case '*gitlab.com*'
            set -gx _git_dir_glyph ' '
            set -gx _git_dir_color E24329
        case '*bitbucket.com*'
            set -gx _git_dir_glyph ' '
            set -gx _git_dir_color 2684FF
        case '*'
            set -gx _git_dir_glyph ' '
            set -gx _git_dir_color F05033
        end
    else
        set -e _git_dir_glyph
        set -e _git_dir_color
    end
end
