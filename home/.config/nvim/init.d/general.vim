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
