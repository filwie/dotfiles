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

set background=dark
let g:gruvbox_italic = 1
let g:gruvbox_contrast_light = 'hard'
let g:gruvbox_termcolors = 0
let g:gruvbox_sign_column = 'bg1'
let g:gruvbox_color_column = 'bg1'
silent! colorscheme gruvbox

highlight Normal            guibg=NONE    ctermbg=NONE
highlight SignColumn        guibg=NONE    ctermbg=NONE
highlight ColorColumn       guibg=NONE    ctermbg=NONE
highlight LineNr            guibg=NONE    ctermbg=NONE    ctermfg=7    guifg=#a89984
highlight CursorLineNr      guibg=NONE    ctermbg=NONE    ctermfg=3    guifg=#fe8019    cterm=bold     gui=bold
highlight Folded            guibg=NONE    ctermbg=NONE
highlight TabLineFill       guibg=NONE    ctermbg=NONE
highlight TabLine           guibg=NONE    ctermbg=NONE
highlight TabLineSel        guibg=NONE    ctermbg=NONE
highlight EndOfBuffer       guibg=NONE    ctermbg=NONE    ctermfg=7    guifg=#1d2021

highlight ALEErrorSign     guibg=NONE    ctermbg=NONE    ctermfg=2    guifg=#d79921
highlight ALEWarningSign   guibg=NONE    ctermbg=NONE    ctermfg=3    guifg=#cc241d

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

set fillchars+=vert:\│  " vert split character set to ' '
highlight VertSplit guibg=NONE ctermbg=NONE ctermfg=8

" Enable italics in comments (important - put after colorscheme)
highlight Comment cterm=italic gui=italic

" Always show signcolumn
if exists('&signcolumn')
  set signcolumn=yes
else
  let g:gitgutter_sign_column_always = 1
endif
