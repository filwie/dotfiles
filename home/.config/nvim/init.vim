" vim: set ts=2 sw=2 fdm=marker:
set encoding=utf-8
scriptencoding utf-8

let g:data_dir = stdpath('data')
let g:conf_dir = stdpath('config')
let g:autoload_dir = g:data_dir . '/site/autoload'
let g:undo_dir = g:data_dir . './undo'

let g:enable_glyphs = get(environ(), 'THEME_ENABLE_GLYPHS', 0) ==# 1

" PLUGINS {{{
let g:plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
let g:plug_path =  g:autoload_dir . '/plug.vim'
let g:plug_dir = g:data_dir . '/plugged'
if empty(glob(g:plug_path))
  echoerr 'Plugin manager missing: ' . g:plug_url . ' -> ' . g:plug_path
end

call plug#begin(g:plug_dir)

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

if ! exists('g:vscode')
    Plug 'gruvbox-community/gruvbox'
    " gruvbox config {{{
    let g:gruvbox_italic = 1
    let g:gruvbox_contrast_light = 'soft'
    let g:gruvbox_contrast_dark = 'hard'
    let g:gruvbox_termcolors = 0
    let g:gruvbox_sign_column = 'bg1'
    let g:gruvbox_color_column = 'bg1'
    " /gruvbox config }}}

    Plug 'dense-analysis/ale'
    " ale config {{{
    let g:ale_echo_msg_format = '[%severity% %linter% %code%]: %s'
    let g:ale_linters = {'python': ['flake8']}
    let g:ale_sign_error = ['E', ' '][g:enable_glyphs]
    let g:ale_sign_warning = ['W', ' '][g:enable_glyphs]
    nnoremap ]e :ALENext<CR>
    nnoremap [e :ALEPrevious<CR>
    " /ale config}}}

    Plug 'sheerun/vim-polyglot'
    " vim-polyglot config {{{
    augroup CustomFileTypes
      autocmd BufRead,BufNewFile **/ansible/**/*.\(yml\|yaml\) set filetype=yaml.ansible
    augroup END
    let g:polyglot_disabled = ['markdown']
    " /vim-polyglot config }}}

    Plug 'tpope/vim-fugitive'

    Plug 'tpope/vim-markdown', {'for': 'markdown'}
    " vim-markdown config {{{
    augroup markdown_inline_code_blocks
      autocmd FileType markdown
            \ let g:markdown_fenced_languages = ['make', 'zsh', 'sh',  'help', 'json', 'tex',
            \ 'sql', 'ruby', 'jinja', 'html', 'css',
            \ 'yaml', 'ansible', 'lua', 'vim', 'java',
            \ 'python', 'javascript', 'xhtml', 'xml', 'c', 'cpp']
    augroup END
    " /vim-markdown config }}}

    Plug 'junegunn/fzf', { 'dir': g:plug_dir . '/fzf', 'do': './install --bin'}
    Plug 'junegunn/fzf.vim'
    " fzf config {{{
    let g:fzf_buffers_jump = 1
    nnoremap <C-p> :FZF<CR>
    nnoremap <C-t> :GFiles<CR>
    nnoremap <C-h> :History:<CR>
    nnoremap <leader>p :Commands<CR>
    nnoremap <leader>m :Marks<CR>
    nnoremap <leader>l :Lines<CR>
    nnoremap <leader>t :Tags<CR>
    nnoremap <leader>b :Buffers<CR>
    nnoremap <leader>g :Rg<CR>
    "/fzf config }}}

    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
    " vim-go config {{{
    let g:go_code_completion_enabled = 0
    " / vim-go config }}}

    Plug 'racer-rust/vim-racer', {'for': 'rust'}
    Plug 'rust-lang/rust.vim', {'for': 'rust'}

    " TODO: only load for some languages
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " coc.nvim config {{{
    let g:coc_snippet_next = '<TAB>'
    let g:coc_snippet_prev = '<S-TAB>'
    let g:coc_status_error_sign = '•'
    let g:coc_status_warning_sign = '•'
    let g:coc_global_extensions = [
          \ 'coc-css',
          \ 'coc-go',
          \ 'coc-emoji',
          \ 'coc-git',
          \ 'coc-highlight',
          \ 'coc-html',
          \ 'coc-lists',
          \ 'coc-pairs',
          \ 'coc-pyright',
          \ 'coc-rls',
          \ 'coc-sh',
          \ 'coc-solargraph',
          \ 'coc-tsserver',
          \ 'coc-vimlsp',
          \ 'coc-yaml',
          \ 'coc-yank'
          \]
    function! CocCurrentFunction()
      return get(b:, 'coc_current_function', '')
    endfunction
    augroup highlight_word_under_cursor
      autocmd!
      autocmd CursorHold * silent call CocActionAsync('highlight')
    augroup END
    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction
    inoremap <silent><expr> <TAB>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<TAB>" :
          \ coc#refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
    inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

    command! -nargs=0 OrganizeImports :call CocAction('runCommand', 'editor.action.organizeImport')
    command! -nargs=0 Format :call CocAction('format')

    nnoremap <silent> gn <Plug>(coc-rename)
    nnoremap <silent> gd <Plug>(coc-definition)
    nnoremap <silent> gy <Plug>(coc-type-definition)
    nnoremap <silent> gi <Plug>(coc-implementation)
    nnoremap <silent> gr <Plug>(coc-references)
    nnoremap <silent> K :call <SID>show_documentation()<CR>
    nnoremap <silent> <leader>y  :<C-u>CocList -A --normal yank<cr>
    " /coc.nvim }}}

    Plug 'valloric/MatchTagAlways', {'for': ['jinja', 'html']}

    Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
    " nerdtree config {{{
    map <C-n> :NERDTreeToggle<CR>
    if g:enable_glyphs
      let NERDTreeDirArrowExpandable = "\u00a0"
      let NERDTreeDirArrowCollapsible = "\u00a0"
    endif
    highlight! link NERDTreeFlags NERDTreeDir
    syntax clear NERDTreeFlags
    let g:NERDTreeMouseMode=3
    let NERDTreeHighlightCursorline=1
    augroup nerdtree_cursor
      autocmd!
      autocmd BufEnter NERD_tree_* highlight CursorLine gui=bold
      autocmd BufEnter NERD_tree_* highlight Cursor guibg=NONE guifg=NONE
      autocmd BufLeave NERD_tree_* highlight clear CursorLine
      autocmd BufAdd * highlight clear CursorLine
    augroup END
    " /nerdtree config }}}

    if g:enable_glyphs
      Plug 'ryanoasis/vim-devicons'
      Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
      " vim-devicons config {{{
      let g:webdevicons_enable = g:enable_glyphs
      let g:DevIconsEnableFoldersOpenClose = 1
      " /vim-devicons config }}}
    endif

    Plug 'ludovicchabant/vim-gutentags'

    Plug 'airblade/vim-gitgutter'
    " vim-gitgutter config {{{
    let g:gitgutter_sign_added =              ['█ ', ' '][g:enable_glyphs]
    let g:gitgutter_sign_modified =           ['█ ', ' '][g:enable_glyphs]
    let g:gitgutter_sign_removed =            ['█ ', ' '][g:enable_glyphs]
    let g:gitgutter_sign_removed_first_line = ['█ ', ' '][g:enable_glyphs]
    let g:gitgutter_sign_modified_removed =   ['█ ', ' '][g:enable_glyphs]
    " /vim-gitgutter config }}}

    Plug 'lmeijvogel/vim-yaml-helper', { 'for': 'yaml' }
    " vim-yaml-helper config {{{
    let g:vim_yaml_helper#auto_display_path = 0
    function! YamlPathYank()
      if &filetype !=# 'yaml'
        echo 'Not a yaml file'
        return 1
      endif
      redir @a
      :YamlDisplayFullPath
      redir END

      normal! f:
      normal! "Ay$
    endfunction

    augroup YamlPluginMapping
      autocmd FileType yaml nnoremap <F3> :call YamlPathYank() <CR>
    augroup END

    nnoremap <leader>a "ap
    nnoremap <leader>* *<C-O>:%s///gn<CR>
    " /vim-yaml-helper config }}}
endif

call plug#end()
" /PLUGINS }}}

" general settings {{{
filetype plugin indent on
set diffopt+=vertical
set laststatus=0
set foldmethod=marker
set hlsearch
set tabstop=4 softtabstop=4 expandtab shiftwidth=4 " autoindent copyindent
set textwidth=0 wrapmargin=0 " dont break lines automatically
set number
set hidden
if &termencoding
  set termencoding=utf-8
endif
if ! &modifiable
  set fileencoding=utf-8
endif
set autowrite
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
set termguicolors
set fillchars+=vert:\│
augroup do_not_insert_comment_character
  autocmd!
  autocmd BufEnter * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
augroup END
augroup json_comments
  autocmd!
  autocmd FileType json syntax match Comment +\/\/.\+$+
augroup END
set timeoutlen=1000 ttimeoutlen=0
set updatetime=300  " smaller updatetime for CursorHold & CursorHoldI
if has('clipboard')
  nnoremap y "+y
  vnoremap y "+y
  set clipboard=unnamedplus
endif
let $UNDODIR = g:undo_dir
set undofile
set undodir=$UNDODIR
set undolevels=1000
set undoreload=10000
if has('persistent_undo')
  call system('mkdir ' . &undodir)
  set undofile
endif
augroup relative_line_numbers
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * if &modifiable | set relativenumber | endif
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END
augroup remove_dangling_spaces
  autocmd!
  autocmd BufWritePre * :%s/\s\+$//e
augroup END
if has('mouse')
  set mouse+=a
  if ! has('nvim')
    if &term =~# '^screen' || &term =~# '^tmux'
      set ttymouse=xterm2
    endif
  endif
endif
augroup termoptions
  autocmd!
  autocmd TermOpen * setlocal nonumber norelativenumber bufhidden=hide
augroup END
" /general settings }}}

" keymap {{{
command! Q q
command! W w
command! Wq wq
noremap  j gj
noremap  k gk
noremap <up> gk
noremap <down> gj
map <C-e> :Explore<CR>
map <leader>vs :source $MYVIMRC<CR>
map <leader>v :vsplit $MYVIMRC<CR>
inoremap <C-c> <Esc><Esc>
tnoremap <Esc> <C-\><C-n>
" /keymap }}}

" theme {{{
silent! colorscheme gruvbox
" palette {{{
let g:colors#palette = {
      \  'dark0_hard':     '#1d2021',
      \  'dark0':          '#282828',
      \  'dark0_soft':     '#32302f',
      \  'dark1':          '#3c3836',
      \  'dark2':          '#504945',
      \  'dark3':          '#665c54',
      \  'dark4':          '#7c6f64',
      \  'dark4_25':       '#7c6f64',
      \  'gray_245':       '#928374',
      \  'gray_244':       '#928374',
      \  'light0_hard':    '#f9f5d7',
      \  'light0':         '#fbf1c7',
      \  'light0_soft':    '#f2e5bc',
      \  'light1':         '#ebdbb2',
      \  'light2':         '#d5c4a1',
      \  'light3':         '#bdae93',
      \  'light4':         '#a89984',
      \  'light4_256':     '#a89984',
      \  'bright_red':     '#fb4934',
      \  'bright_green':   '#b8bb26',
      \  'bright_yellow':  '#fabd2f',
      \  'bright_blue':    '#83a598',
      \  'bright_purple':  '#d3869b',
      \  'bright_aqua':    '#8ec07c',
      \  'bright_orange':  '#fe8019',
      \  'neutral_red':    '#cc241d',
      \  'neutral_green':  '#98971a',
      \  'neutral_yellow': '#d79921',
      \  'neutral_blue':   '#458588',
      \  'neutral_purple': '#b16286',
      \  'neutral_aqua':   '#689d6a',
      \  'neutral_orange': '#d65d0e',
      \  'faded_red':      '#9d0006',
      \  'faded_green':    '#79740e',
      \  'faded_yellow':   '#b57614',
      \  'faded_blue':     '#076678',
      \  'faded_purple':   '#8f3f71',
      \  'faded_aqua':     '#427b58',
      \  'faded_orange':   '#af3a03',
      \}
" /palette }}}

" highlight helper {{{
function! s:PaletteHL(hlgroup, bg, fg_dark, fg_light) abort
  if empty(g:colors#palette)
    echom 'Global variable g:colors#palette is not set correctly'
  endif

  let l:bg_hex = get(g:colors#palette, a:bg, 'NONE')
  let l:fg_hex = get(g:colors#palette,
        \ {'light': a:fg_light, 'dark': a:fg_dark}[&background],
        \ 'NONE')

  execute 'highlight ' . a:hlgroup . ' guibg=' . l:bg_hex . ' guifg=' . l:fg_hex
endfunction
" /highlight helper }}}

highlight Normal guibg=NONE guifg=NONE

call s:PaletteHL('SignColumn', '', 'light0', 'dark0')
call s:PaletteHL('ColorColumn', '', 'bright_orange', 'faded_orange')

call s:PaletteHL('LineNr', '', 'dark4', 'light4')
call s:PaletteHL('CursorLineNr', '', 'bright_orange', 'faded_orange')
call s:PaletteHL('Folded', '', 'dark4', 'faded_orange')

call s:PaletteHL('EndOfBuffer', '', 'dark0_hard', 'light0_hard')
call s:PaletteHL('VertSplit', '', 'dark1', 'light1')

call s:PaletteHL('GitGutterAdd', '', 'neutral_green', 'neutral_green')
call s:PaletteHL('GitGutterChange', '', 'neutral_yellow', 'neutral_yellow')
call s:PaletteHL('GitGutterDelete', '', 'neutral_red', 'neutral_red')

call s:PaletteHL('ALEErrorSign', '', 'neutral_red', 'neutral_red')
call s:PaletteHL('ALEWarningSign', '', 'neutral_yellow', 'neutral_yellow')
call s:PaletteHL('ALEInfoSign', '', 'neutral_blue', 'neutral_blue')

highlight link GitGutterChangeDelete GitGutterChange
highlight Comment gui=italic
" /theme }}}
