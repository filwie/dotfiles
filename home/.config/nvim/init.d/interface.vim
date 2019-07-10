if has('mouse')
    " try a, r, v
    " set ttymouse=xterm2
    set mouse+=a
    if ! has('nvim')
        if &term =~ '^screen' || &term =~ '^tmux'
            " Enable extended mouse while using tmux
            set ttymouse=xterm2
        endif
    endif
endif

let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" cursor changes in insert mode
if has("nvim")
    let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1
endif

if has("linux")
    let &t_SI = "\<Esc>[6 q"
    let &t_SR = "\<Esc>[4 q"
    let &t_EI = "\<Esc>[2 q"
elseif has("unix")
    if exists('$TMUX')
        let &t_SI = "\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\"
        let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
    else
        let &t_SI = "\<Esc>]1337;CursorShape=1\x7"
        let &t_EI = "\<Esc>]1337;CursorShape=0\x7"
    endif
endif

set fillchars+=vert:\│

" Always show signcolumn
if exists('&signcolumn')
  set signcolumn=yes
else
  let g:gitgutter_sign_column_always = 1
endif
