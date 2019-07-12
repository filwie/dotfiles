filetype plugin indent on
set diffopt+=vertical
set laststatus=1
set foldmethod=marker
set hlsearch
set tabstop=4 softtabstop=4 expandtab shiftwidth=4 " autoindent copyindent
set textwidth=0 wrapmargin=0 " dont break lines automatically
set number
set termencoding=utf-8
set fileencoding=utf-8
set encoding=utf8
set backspace=indent,eol,start
set splitright
set ruler
set noswapfile
set ignorecase
set incsearch
set scrolloff=10
set showmatch
set showmode
set history=1000
set showcmd
set wildmenu
set wildmode=list:longest,full
set autoread
set modeline  " WARNING: there have been modeline-based vulnerabilities in the past
set colorcolumn=80
set termguicolors
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o  " no automatic comment char inserting
set timeoutlen=1000 ttimeoutlen=0
"set cmdheight=2  " better visibility of messages
set updatetime=300  " smaller updatetime for CursorHold & CursorHoldI

augroup clipboard
    if has('clipboard')
        nnoremap y "+y
        vnoremap y "+y
        set clipboard=unnamedplus
    endif
augroup END

augroup persistentundo
    set undofile
    set undodir=$HOME/.vim/undo
    set undolevels=1000
    set undoreload=10000
    let undodir='$HOME/.vim/undo'

    if has('persistent_undo')
        call system('mkdir ' . undodir)
        set undofile
    endif
augroup END

augroup relativenumbers
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * if &modifiable | set relativenumber | endif
    autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

augroup removetrailingwhitespaces
    autocmd!
    autocmd BufWritePre * :%s/\s\+$//e
augroup END

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
