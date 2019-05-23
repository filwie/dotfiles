filetype plugin indent on
set diffopt+=vertical
set laststatus=1
set foldmethod=marker
set tabstop=4 softtabstop=4 expandtab shiftwidth=4  " autoindent copyindent
set textwidth=0 wrapmargin=0  " dont break lines automatically
set number
set termencoding=utf-8 fileencoding=utf-8 encoding=utf8
set backspace=indent,eol,start
set splitright
set ruler
set noswapfile
set ignorecase incsearch hlsearch
set scrolloff=10  " keep cursor N lines from top/bottom of the window
set showmatch showmode showcmd
set history=1000
set wildmenu
set wildmode=list:longest,full
set background=light
" set termguicolors
set modeline  " WARNING: there have been modeline-based vulnerabilities in the past
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o  " no automatic comment char inserting
set timeoutlen=1000 ttimeoutlen=0

if has('clipboard')
    nnoremap y "+y
    vnoremap y "+y
    set clipboard=unnamedplus
endif

let &undodir=glob('~/.local/share/vim/undo')
if has('persistent_undo')
    set undolevels=1000
    set undoreload=10000
    silent call system('mkdir -p ' . &undodir)
    set undofile
endif

autocmd BufEnter,FocusGained,InsertLeave * if &modifiable | set relativenumber | endif
autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber

autocmd BufWritePre * :%s/\s\+$//e

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
