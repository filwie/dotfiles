" theme properties {{{
set background=dark
let g:gruvbox_italic = 1
let g:gruvbox_contrast_light = 'hard'
let g:gruvbox_termcolors = 0
let g:gruvbox_sign_column = 'bg1'
let g:gruvbox_color_column = 'bg1'
" /theme properties }}}

silent! colorscheme gruvbox

" color variables {{{
let s:dark0_hard     = '#1d2021'
let s:dark0          = '#282828'
let s:dark0_soft     = '#32302f'
let s:dark1          = '#3c3836'
let s:dark2          = '#504945'
let s:dark3          = '#665c54'
let s:dark4          = '#7c6f64'
let s:dark4_256      = '#7c6f64'

let s:gray_245       = '#928374'
let s:gray_244       = '#928374'

let s:light0_hard    = '#f9f5d7'
let s:light0         = '#fbf1c7'
let s:light0_soft    = '#f2e5bc'
let s:light1         = '#ebdbb2'
let s:light2         = '#d5c4a1'
let s:light3         = '#bdae93'
let s:light4         = '#a89984'
let s:light4_256     = '#a89984'

let s:bright_red     = '#fb4934'
let s:bright_green   = '#b8bb26'
let s:bright_yellow  = '#fabd2f'
let s:bright_blue    = '#83a598'
let s:bright_purple  = '#d3869b'
let s:bright_aqua    = '#8ec07c'
let s:bright_orange  = '#fe8019'

let s:neutral_red    = '#cc241d'
let s:neutral_green  = '#98971a'
let s:neutral_yellow = '#d79921'
let s:neutral_blue   = '#458588'
let s:neutral_purple = '#b16286'
let s:neutral_aqua   = '#689d6a'
let s:neutral_orange = '#d65d0e'

let s:faded_red      = '#9d0006'
let s:faded_green    = '#79740e'
let s:faded_yellow   = '#b57614'
let s:faded_blue     = '#076678'
let s:faded_purple   = '#8f3f71'
let s:faded_aqua     = '#427b58'
let s:faded_orange   = '#af3a03'
" /color variables }}}

function! s:hifg(group, fg_rgb)
    let l:hlstr = 'highlight ' . a:group . ' guibg=NONE guifg=' . a:fg_rgb
    echo l:hlstr
    execute
endfunction

call s:hifg('Normal', '')
call s:hifg('SignColumn', '')
call s:hifg('ColorColumn', '')
call s:hifg('LineNr', s:dark2)
call s:hifg('CursorLineNr', s:light2)
call s:hifg('Folded', s: dark2)
call s:hifg('TabLineFill', '')
call s:hifg('TabLine', '')
call s:hifg('TabLineSel', '')
call s:hifg('EndOfBuffer', '')
call s:hifg('VertSplit', '')

call s:hifg('ALEErrorSign', '')
call s:hifg('ALEWarningSign', '')

call s:hifg('GitAdd', '')
call s:hifg('GitChange', '')
call s:hifg('GitDelete', '')

highlight link GitChangeDelete GitChange

highlight Comment           cterm=italic  gui=italic
