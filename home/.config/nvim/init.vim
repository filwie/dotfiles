" vim: set fdm=marker ts=2 sw=2 et:
scriptencoding utf-8
set shell=$VIM_SHELL

" INSTALL VIM PLUG {{{
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
if has('nvim')
  if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
endif
" }}}

" PLUGIN VARIABLES {{{
let g:ctags_supported_languages = ['ansible', 'assembler', 'awk', 'bash', 'c', 'cpp', 'erlang', 'fortran', 'html', 'java', 'javascript', 'lisp', 'lua', 'make', 'matlab', 'pascal', 'perl', 'php', 'sql', 'python', 'rexx', 'ruby', 'scheme', 'sh', 'tcl', 'tex', 'vim', 'vimscript', 'yacc', 'yaml', 'zsh']
let g:languages_to_lint = ['python', 'css', 'html', 'java', 'c', 'cpp', 'yaml', 'ansible', 'markdown', 'vim']
let g:tag_languages = ['html', 'xml', 'xhtml', 'jinja']
"}}}

" PLUGINS LIST {{{
" Sorted alphabetically by plugin name `sort i /^\(Plug.*\/\|Plug.*\$\)/`
if has('nvim')
  call plug#begin('~/.local/share/nvim/plugged')
else
  call plug#begin('~/.vim/plugged')
endif
Plug 'w0rp/ale', {'for': g:languages_to_lint}
Plug 'pearofducks/ansible-vim'
Plug 'skywind3000/asyncrun.vim'
Plug 'ekalinin/Dockerfile.vim'
Plug $FZF_BASE
Plug 'junegunn/fzf.vim'
Plug 'morhetz/gruvbox'
Plug 'mboughaba/i3config.vim'
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'Shougo/deoplete-clangx', {'for': ['c', 'c++']}
Plug 'deoplete-plugins/deoplete-go', {'for': ['go']}
Plug 'deoplete-plugins/deoplete-jedi', {'for': ['python']}
Plug 'artur-shaik/vim-javacomplete2', {'for': ['java']}
Plug 'racer-rust/vim-racer', {'for': ['rust']}
Plug 'valloric/MatchTagAlways', {'for': g:tag_languages}
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'vim-python/python-syntax'
Plug 'srcery-colors/srcery-vim'
Plug 'ervandew/supertab'
Plug 'majutsushi/tagbar', {'for': g:ctags_supported_languages}
Plug 'tell-k/vim-autopep8', {'for': 'python'}
Plug 'rhysd/vim-clang-format', {'for': ['c', 'c++']}
Plug 'ap/vim-css-color'
Plug 'ryanoasis/vim-devicons', { 'on': 'NERDTreeToggle' }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'airblade/vim-gitgutter'
Plug 'ludovicchabant/vim-gutentags'
Plug 'glench/vim-jinja2-syntax'
Plug 'terryma/vim-multiple-cursors'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight', { 'on': 'NERDTreeToggle' }
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-surround'
Plug 'nathanielc/vim-tickscript', {'for': 'tick'}
Plug 'dag/vim-fish'
Plug 'zefei/vim-wintabs'
call plug#end()
" }}}

" PLUGIN SETTINGS {{{
" Ansible-vim
" below might not work with jinja plugins
let g:ansible_template_syntaxes = {
      \ '*.ini.j2': 'dosini',
      \ '*.json.j2': 'json',
      \ '*.yaml.j2': 'yaml',
      \ '*.yml.j2': 'yaml',
      \}

" Ale
let g:ale_echo_msg_format = '[%severity%][%linter%][%code%]: %s'

" Autopep8
let g:autopep8_disable_show_diff=0
let g:autopep8_ignore='E501'  " ignore specific PEP8 (line too long,)

" Deoplete
let g:deoplete#enable_at_startup = 1

" Deoplete - java
let g:JavaComplete_Home = $HOME . '/.local/share/nvim/plugged/vim-javacomplete2/libs/javavi'
let $CLASSPATH .= '.:' . $HOME . '/.local/share/nvim/plugged/vim-javacomplete2/libs/javavi/target/classes'

" NERDTree
let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = 'ﱮ'
let g:NERDTreeMouseMode=3

" Python-syntax
let g:python_highlight_all = 1

" Webdevicons
let g:WebDevIconsUnicodeDecorateFolderNodes = 0

" YouCompleteMe
if has('nvim')
  let g:ycm_global_ycm_extra_conf = '$XDG_CONFIG_HOME/nvim/ycm_extra_conf.py'
else
  let g:ycm_global_ycm_extra_conf = '$HOME/.vim/.ycm_extra_conf.py'
end
let g:ycm_autoclose_preview_window_after_insertion = 1

" Supertab
let g:SuperTabDefaultCompletionType = "<c-n>"

" Tagbar
let g:tagbar_type_ansible = {'ctagstype' : 'ansible', 'kinds' : ['t:tasks'], 'sort' : 0}

" toggle quickfix window
nnoremap <leader>q :call asyncrun#quickfix_toggle(6)<CR>

" Wintabs
let g:wintabs_ui_modified=' (m)'
let g:wintabs_ui_readonly=' (ro)'
let g:wintabs_ui_sep_leftmost=''
let g:wintabs_ui_sep_inbetween=''
let g:wintabs_ui_sep_rightmost=''

" }}}

" KEYMAP {{{

" now Q and W also work - my most common mistype
command! Q q
command! W w
command! Wq wq

" Move up/down on visual lines (wrapped work like no wrapped)
noremap  j gj
noremap  k gk
noremap <up> gk
noremap <down> gj

" Map familiar C-p to use fzf
map <C-p> :FZF<CR>
map <C-t> :GFiles<CR>
map <leader>p :Commands<CR>

map <leader>t :Tags<CR>
map <leader>b :Buffers<CR>

map <leader>nt :NERDTreeToggle<CR>
map <F8> :TagbarToggle<CR>
map <leader>jd :YcmCompleter GoTo<CR>



" maps for sourcing, opening and autosourcing .vimrc
map <leader>vs :source $MYVIMRC<CR>
map <leader>v :vsplit $MYVIMRC<CR>

" map for reloading the config and restarting i3
map <leader>i3 :!link_dotfiles.sh<CR> <bar> :!i3-merge-conf.sh<CR> <bar> :AsyncRun i3-msg reload; i3-msg restart<CR>

" leave INSERT mode using C-c
inoremap <C-c> <Esc><Esc>

" ----- Command mapping -----
" Format and Sort JSON
com! FormatJSON %!python -m json.tool

" }}}

" FILETYPE-SPECIFIC {{{
augroup python
  autocmd!
  autocmd FileType python nnoremap <buffer> <F10> :term python3 %<CR>
  autocmd FileType python nnoremap <buffer> <F9> :term pytest<CR>
  autocmd FileType python nnoremap <leader>8 :Autopep8<CR>
augroup END

augroup java
  autocmd!
  autocmd FileType java nnoremap <buffer> <F10> :term javac % && java %:r <CR>
augroup END

augroup term
  autocmd BufWinEnter,WinEnter term://* startinsert
  tnoremap <Esc> <C-\><C-n>:q!<CR>
augroup END

augroup ansible
  autocmd!
  autocmd BufRead,BufNewFile */ansible/*.yml set filetype=yaml.ansible
  autocmd FileType yaml.ansible,yaml,ansible nnoremap <buffer> <F9> :exec '!clear; ansible-playbook' shellescape(@%, 1)<CR>
  autocmd Filetype yaml setlocal ts=2 sw=2 sts=2 expandtab
augroup END

augroup ccpp
  autocmd!
  autocmd FileType c nnoremap <silent> <F9> :AsyncRun gcc -Wall -O2 "$(VIM_FILEPATH)" -o "$(VIM_FILEDIR)/$(VIM_FILENOEXT)" <CR>
  autocmd FileType cpp nnoremap <F9> :AsyncRun g++ -Wall -O2 "$(VIM_FILEPATH)" -o "$(VIM_FILEDIR)/$(VIM_FILENOEXT)" <CR>
  autocmd FileType c,cpp nnoremap <buffer> <F10> :exec '!clear; %:p:h/%:r' <CR>
  autocmd FileType c,cpp nnoremap <leader>8 :ClangFormat<CR>
augroup END

augroup vimscript
  autocmd!
  autocmd Filetype vim nnoremap <buffer> <F10> :exec '!clear' <bar> source % <CR>
augroup END

augroup markdown
  autocmd!
  autocmd FileType markdown nnoremap <buffer> <F10> :AsyncRun  grip "${VIM_FILEPATH}" --export "/tmp/${VIM_FILENOEXT}.html" && xdg-open "/tmp/${VIM_FILENOEXT}.html"<CR>
augroup END


" GENERAL {{{
filetype plugin indent on
set diffopt+=vertical
set laststatus=1
set foldmethod=marker
set hlsearch
set tabstop=4 softtabstop=4 expandtab shiftwidth=4 " autoindent copyindent
" dont break lines automatically
set textwidth=0 wrapmargin=0
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
" set timeoutlen=1000 ttimeoutlen=0

augroup noautomaticcommentcharacter
  autocmd!
  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
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

let g:markdown_fenced_languages = ['make', 'zsh', 'sh', 'json', 'tex', 'sql', 'ruby', 'jinja', 'html', 'css', 'yaml', 'ansible', 'lua', 'vim', 'java', 'python', 'javascript', 'xhtml', 'xml', 'c', 'cpp']

" }}}

" MOUSE {{{
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
" }}}

" CLIPBOARD {{{
augroup clipboard
    if has('clipboard')
      nnoremap y "+y
      vnoremap y "+y
      set clipboard=unnamedplus
    endif
augroup END
"}}}

" THEMING, VISUAL TWEAKS {{{
" gruvbox {{{
set background=light
let g:gruvbox_italic = 1
let g:gruvbox_contrast_light = 'soft'
let g:gruvbox_termcolors = 1
let g:gruvbox_sign_column = 'bg0'
let g:gruvbox_color_column = 'bg0'
silent! colorscheme gruvbox
" }}}

" highlight Normal            guibg=NONE    ctermbg=NONE
" highlight SignColumn        guibg=NONE    ctermbg=NONE
" highlight ColorColumn       guibg=NONE    ctermbg=NONE    guifg=gb.light1  ctermfg=1
" highlight LineNr            guibg=NONE    ctermbg=NONE    guifg=gb.neutral_red[0]  ctermfg=7
" highlight CursorLineNr      guibg=NONE    ctermbg=NONE    cterm=bold
highlight Folded            guibg=NONE    ctermbg=NONE
highlight TabLineFill       guibg=NONE    ctermbg=NONE
highlight TabLine           guibg=NONE    ctermbg=NONE
highlight TabLineSel        guibg=NONE    ctermbg=NONE
" highlight EndOfBuffer       guibg=NONE    ctermbg=NONE    guifg=gb.light0_soft    ctermfg=0



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
highlight Comment cterm=italic

" }}}

" GVIM {{{
if has("gui_running")
  silent colorscheme srcery
  highlight SignColumn guibg=background
  set guioptions=
  set guifont=Iosevka\ 14
  set autochdir
  set shell=/bin/zsh
  let g:webdevicons_enable = 0
endif
" }}}