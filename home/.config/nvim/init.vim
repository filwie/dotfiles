" vim: set ts=2 sw=2 fdm=marker:
scriptencoding utf-8

" environment {{{
if ! $VIM_SHELL ==# '' | set shell=$VIM_SHELL | endif
if ! $THEME_ENABLE_GLYPHS ==# ''
  let g:enable_glyphs=1
else
  let g:enable_glyphs=0
endif
" /environment }}}

" helpers {{{
function! InstallVimPlug ()
  let l:plug_download_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  if has('nvim') | let l:plug_install_path = '~/.local/share/nvim/site/autoload/plug.vim'
  else           | let l:plug_install_path = '~/.vim/autoload/plug.vim' | endif
  if empty(glob(l:plug_install_path))
    echo 'VimPlug not found - attempting to install.'
    execute '!curl --create-dirs -fLo ' . l:plug_install_path  l:plug_download_url
    echo 'Installing plugins'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
endfunction
function! UpdateRP(info)
  if has('nvim')
    silent UpdateRemotePlugins
    echomsg 'Remote plugin updated: ' . a:info['name'] . '. Restart NeoVim for changes to take effect.'
  endif
endfunction
" /helpers }}}

call InstallVimPlug()

" global variables {{{
"" gruvbox neutral colors {{{
let g:gruvbox_palette = {
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
      \  'faded_orange':   '#af3a03'
      \}
"" /gruvbox neutral colors }}}
" /global variables }}}

" plugins {{{
let g:nvim_plugin_dir = '~/.local/share/nvim/plugged'
call plug#begin(g:nvim_plugin_dir)

" For running linters asyncronously
Plug 'dense-analysis/ale'
" ale config {{{
let g:ale_echo_msg_format = '[%severity% %linter% %code%]: %s'
let g:ale_linters = {'python': ['flake8']}
if g:enable_glyphs
  let g:ale_sign_error = ' '
  let g:ale_sign_warning = ' '
else
  let g:ale_sign_error = 'E'
  let g:ale_sign_warning = 'W'
endif
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
augroup MarkdownCodeBlocks
  autocmd FileType markdown
        \ let g:markdown_fenced_languages = ['make', 'zsh', 'sh',  'help', 'json', 'tex',
        \ 'sql', 'ruby', 'jinja', 'html', 'css',
        \ 'yaml', 'ansible', 'lua', 'vim', 'java',
        \ 'python', 'javascript', 'xhtml', 'xml', 'c', 'cpp']
augroup END
" /vim-markdown config }}}

Plug 'junegunn/fzf', { 'dir': g:nvim_plugin_dir . '/fzf', 'do': './install --bin'}
Plug 'junegunn/fzf.vim'
" fzf config {{{
nnoremap <C-f><C-p> :FZF<CR>

nnoremap <C-p> :FZF<CR>
nnoremap <C-t> :GFiles<CR>
nnoremap <C-h> :History:<CR>
vnoremap <C-h> :History:<CR>

nnoremap <leader>p :Commands<CR>
nnoremap <leader>m :Marks<CR>
nnoremap <leader>l :Lines<CR>
nnoremap <leader>t :Tags<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>g :Rg<CR>

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

augroup fzf_window_tweak
  autocmd! FileType fzf
  autocmd  FileType fzf set noshowmode noruler laststatus=0
        \| autocmd BufLeave <buffer> set showmode ruler laststatus=0
augroup END

if has('nvim')
  let $FZF_DEFAULT_OPTS .= ' --border --margin=0,2 --reverse'

  function! FloatingFZF()
    let width = float2nr(&columns * 0.8)
    let height = float2nr(&lines * 0.6)
    let opts = { 'relative': 'editor',
               \ 'row': (&lines - height) / 2,
               \ 'col': (&columns - width) / 2,
               \ 'width': width,
               \ 'height': height }

    let win = nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    call setwinvar(win, '&winhighlight', 'NormalFloat:Normal')
  endfunction

  let g:fzf_layout = { 'window': 'call FloatingFZF()' }
endif
"/fzf config }}}

Plug 'morhetz/gruvbox'
Plug 'junegunn/goyo.vim', {'on': 'Goyo'}
" goyo.vim config {{{
augroup goyofixhighlight
autocmd! User GoyoLeave silent! source $MYVIMRC
augroup END
" / goyo.vim config }}}

" go {{{
Plug 'stamblerre/gocode', { 'rtp': 'nvim', 'do': '~/.local/share/nvim/plugged/gocode/nvim/symlink.sh' }
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
" vim-go config {{{
let g:go_term_mode = "split"

" /vim-go config}}}
" /go }}}

" python {{{
Plug 'tell-k/vim-autopep8', {'for': 'python'}
" vim-autopep8 congfig {{{
let g:autopep8_disable_show_diff=0
let g:autopep8_ignore='E501'
"" /vim-autopep8 config }}}
" /python }}}

" rust {{{
Plug 'racer-rust/vim-racer'
Plug 'rust-lang/rust.vim'
" /rust }}}

Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'}
" coc.nvim config {{{
let g:coc_snippet_next = '<TAB>'
let g:coc_snippet_prev = '<S-TAB>'
let g:coc_status_error_sign = '•'
let g:coc_status_warning_sign = '•'
let g:coc_global_extensions = [
      \ 'coc-git',
      \ 'coc-pairs',
      \ 'coc-highlight',
      \ 'coc-lists',
      \ 'coc-yank',
      \ 'coc-yaml',
      \ 'coc-rls',
      \ 'coc-python',
      \ 'coc-vimlsp',
      \ 'coc-tsserver',
      \ 'coc-gocode',
      \ 'coc-html',
      \ 'coc-css'
      \]

function! CocCurrentFunction()
  return get(b:, 'coc_current_function', '')
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

"Use tab for trigger completion with characters ahead and navigate
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)

nnoremap <silent> K :call <SID>show_documentation()<CR>

nnoremap <silent> <leader>y  :<C-u>CocList -A --normal yank<cr>
" /coc.nvim }}}

Plug 'valloric/MatchTagAlways', {'for': ['jinja', 'html']}

Plug 'terryma/vim-multiple-cursors'
" vim-multiple-cursors config {{{
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_start_word_key      = '<C-d>'
let g:multi_cursor_select_all_word_key = '<A-n>'
let g:multi_cursor_start_key           = 'g<C-n>'
let g:multi_cursor_select_all_key      = 'g<A-n>'
let g:multi_cursor_next_key            = '<C-d>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'
" /vim-multiple-cursors config }}}

Plug 'itchyny/lightline.vim'
" lightline config {{{
function! CocCurrentFunction()
  return get(b:, 'coc_current_function', '')
endfunction
function! LightlineGitBlame() abort
  let blame = get(b:, 'coc_git_blame', '')
  " return blame
  return winwidth(0) > 120 ? blame : ''
endfunction
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left': [
      \     [ 'mode', 'paste' ],
      \     [ 'cocstatus', 'currentfunction', 'readonly', 'filename', 'modified' ]
      \   ],
      \   'right':[
      \     [ 'filetype', 'fileencoding', 'blame', 'percent' ],
      \     [ 'lineinfo' ]
      \   ],
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status',
      \   'currentfunction': 'CocCurrentFunction',
      \   'blame': 'LightlineGitBlame'
      \ },
      \ }
" /lightline config }}}

Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
" nerdtree config {{{
map <C-n> :NERDTreeToggle<CR>
if g:enable_glyphs
  let NERDTreeDirArrowExpandable = "\u00a0"
  let NERDTreeDirArrowCollapsible = "\u00a0"
else
  let g:NERDTreeDirArrowExpandable = '▸'
  let g:NERDTreeDirArrowCollapsible = '▾'
endif
highlight! link NERDTreeFlags NERDTreeDir
syntax clear NERDTreeFlags
let g:NERDTreeMouseMode=3
let NERDTreeHighlightCursorline=1
augroup NerdCursor
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

Plug 'liuchengxu/vista.vim', { 'on': 'Vista' }
" vista config {{{
nnoremap <F8> :Vista<CR>

let g:vista#renderer#enable_icon = g:enable_glyphs
" let g:vista_default_executive = 'ctags'
let g:vista_icon_indent = ["▸ ", ""]
let g:vista_fzf_preview = ['right:50%']
let g:vista_executive_for = {
      \ 'go': 'ctags',
      \ 'javascript': 'coc',
      \ 'javascript.jsx': 'coc',
      \ 'python': 'coc',
      \ }
" /vista config }}}

Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

Plug 'ludovicchabant/vim-gutentags'

Plug 'airblade/vim-gitgutter'
" vim-gitgutter config {{{
if g:enable_glyphs
  let g:gitgutter_sign_added = ' '
  let g:gitgutter_sign_modified = ' '
  let g:gitgutter_sign_removed = ' '
  let g:gitgutter_sign_removed_first_line = ' '
  let g:gitgutter_sign_modified_removed = ' '
else
  let g:gitgutter_sign_added = '█ '
  let g:gitgutter_sign_modified = '█ '
  let g:gitgutter_sign_removed = '█ '
  let g:gitgutter_sign_removed_first_line = '█ '
  let g:gitgutter_sign_modified_removed = '█ '
endif
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

call plug#end()
" /PLUGIN LIST }}}

" general settings {{{
filetype plugin indent on
set diffopt+=vertical
set laststatus=0
function! LastStatusToggle()
  if &laststatus == 0 || &laststatus == 1
    set laststatus=2
  else
    set laststatus=0
  endif
endfunction
set foldmethod=marker
set hlsearch
set tabstop=4 softtabstop=4 expandtab shiftwidth=4 " autoindent copyindent
set textwidth=0 wrapmargin=0 " dont break lines automatically
set number
set hidden
if &termencoding | set termencoding=utf-8 | endif
if !&modifiable | set fileencoding=utf-8 | endif
set autowrite
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
set fillchars+=vert:\│
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o  " no automatic comment char inserting
autocmd FileType json syntax match Comment +\/\/.\+$+
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
augroup termoptions
  autocmd!
  autocmd TermOpen * setlocal nonumber norelativenumber bufhidden=hide
augroup END
augroup insertmodecursor  "{{{
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
augroup END  "}}}
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
nnoremap <leader>s :call LastStatusToggle()<CR>
" /keymap }}}

" filetype specific confg {{{
let s:_run = '<F10>'
let s:_fmt = '<leader>8'
let s:_test = '<leader>te'
let s:_build = '<F9>'

let g:user_mappings=[s:_run, s:_fmt, s:_test, s:_build]

function! FileTypeMap(filetypes, ...)  "{{{
  " Arguments: filetypes, run, format, test, build
  let l:i = 0
  for cmd in a:000
    let s:parts = ['autocmd FileType', join(a:filetypes, ','),
          \ 'nnoremap', g:user_mappings[i], cmd, '<CR>']
    execute join(s:parts, ' ')
    let l:i = l:i + 1
  endfor
endfunction  " }}}

function! MarkdownConvertOpen()  "{{{
  if ! executable('grip')
    echom 'grip not found. Run: pip install -U grip'
    return
  endif
  let l:open_html_cmd = 'xdg-open'
  if has('macunix')
    let l:open_html_cmd = 'open'
  endif

  let l:outfile = expand('/tmp/%:t:r.html')
  let l:export = '!grip % --export ' . l:outfile
  let l:open = join([l:open_html_cmd, l:outfile], ' ')
  execute join([l:export, l:open], ' && ')
endfunction  "}}}

function! FormatJSON()  " {{{
  execute ':%!python -m json.tool'
endfunction  "}}}

let s:_nm = ':echom "mapping not specified"'

let g:python_interpreter = 'python'
if $PYTHON_INTERPRETER != '' && executable($PYTHON_INTERPRETER)
  let g:python_interpreter = $PYTHON_INTERPRETER
endif
call FileTypeMap(['python'], ':term ' . g:python_interpreter . ' %', ':Autopep8', ':term pytest')
call FileTypeMap(['ruby'], ':term ruby %')
call FileTypeMap(['bash', 'sh'], ':term./%')
call FileTypeMap(['rust'], ':RustRun', ':RustFmt', ':RustTestterm')
call FileTypeMap(['java'], ':term javac % && java run %:r', s:_nm, s:_nm, ':term javac %')
call FileTypeMap(['go'], ':GoRun', ':GoFmt', ':GoTest', ':GoBuild')
call FileTypeMap(['json'], s:_nm, ':%termpython -m json.tool')
call FileTypeMap(['ansible', 'ansible.yaml', 'yaml.ansible'], ':term ansible-playbook %')
call FileTypeMap(['vim'], ':source %')
call FileTypeMap(['markdown'], ':call MarkdownConvertOpen()')
call FileTypeMap(['nim'], ':term nim compile --run %')
" /filetype specific config }}}

" theme {{{
if $THEME_BACKGROUND ==# 'light'
  set background=light
else
  set background=dark
endif

let g:gruvbox_italic = 1
let g:gruvbox_contrast_light = 'soft'
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_termcolors = 0
let g:gruvbox_sign_column = 'bg1'
let g:gruvbox_color_column = 'bg1'

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

function! s:hifg(group, bg, fg)
  " Arguments: group, guibg, guifg
  let l:hl = ['highlight ', a:group,
        \ 'guibg=' . a:bg,
        \ 'guifg=' . a:fg ]

  execute join(l:hl, ' ')
endfunction

if &background ==# 'dark'
  call s:hifg('Normal', 'NONE', s:light0_hard)
  call s:hifg('SignColumn', 'NONE', s:light0)
  call s:hifg('ColorColumn','NONE', s:bright_orange)
  call s:hifg('LineNr', 'NONE', s:dark2)
  call s:hifg('CursorLineNr', 'NONE',  s:light2)
  call s:hifg('Folded', 'NONE', s:dark2)

  call s:hifg('EndOfBuffer', 'NONE',  s:dark0_hard)
  call s:hifg('VertSplit', 'NONE',  s:dark1)

  call s:hifg('ALEErrorSign', 'NONE',  s:bright_red)
  call s:hifg('ALEWarningSign', 'NONE',  s:bright_yellow)

  call s:hifg('GitGutterAdd', 'NONE',  s:faded_green)
  call s:hifg('GitGutterChange', 'NONE',  s:faded_yellow)
  call s:hifg('GitGutterDelete', 'NONE',  s:faded_red)
  execute 'highlight CursorLine guibg=' . s:dark0
else
  call s:hifg('Normal', 'NONE', s:dark0_soft)
  call s:hifg('SignColumn', 'NONE', s:dark0_soft)
  call s:hifg('ColorColumn','NONE', s:faded_orange)
  call s:hifg('LineNr', 'NONE', s:light2)
  call s:hifg('CursorLine', s:light2,  'NONE')
  call s:hifg('CursorLineNr', 'NONE',  s:dark2)
  call s:hifg('Folded', 'NONE', s:dark2)

  call s:hifg('EndOfBuffer', 'NONE',  s:dark0_hard)
  call s:hifg('VertSplit', 'NONE',  s:dark1)

  call s:hifg('ALEErrorSign', 'NONE',  s:faded_red)
  call s:hifg('ALEWarningSign', 'NONE',  s:faded_yellow)

  call s:hifg('GitGutterAdd', 'NONE',  s:faded_green)
  call s:hifg('GitGutterChange', 'NONE',  s:faded_yellow)
  call s:hifg('GitGutterDelete', 'NONE',  s:faded_red)
  execute 'highlight CursorLine guibg=' . s:dark0
endif

highlight link GitGutterChangeDelete GitGutterChange
highlight Comment cterm=italic  gui=italic
" /theme }}}
