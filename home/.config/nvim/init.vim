" vim: set ts=2 sw=2 fdm=marker:
scriptencoding utf-8

let $XDG_DATA_HOME = get(environ(), 'XDG_DATA_HOME', $HOME . '/.local/share/')
let g:filwie#enable_glyphs = ! $THEME_ENABLE_GLYPHS ==# ''
let g:filwie#_autoload_directories = [
      \ $HOME . '/.vim/autoload/',
      \ $XDG_DATA_HOME . '/nvim/site/autoload'
      \ ]
let g:filwie#autoload_directory =
      \ g:filwie#_autoload_directories[has('nvim')]
let g:filwie#vimplug_download_url =
      \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
let g:filwie#vimplug_install_path = g:filwie#autoload_directory . '/plug.vim'
let g:filwie#vimplug_plugin_directory = $XDG_DATA_HOME . '/nvim/plugged'

if empty(glob(g:filwie#vimplug_install_path))
    call helpers#EnsureVimPlugIsInstalled(
                \ g:filwie#vimplug_download_url,
                \ g:filwie#vimplug_install_path)
end

" plugins {{{
call plug#begin(g:filwie#vimplug_plugin_directory)

Plug 'morhetz/gruvbox'
" gruvbox config {{{
let g:gruvbox_italic = 1
let g:gruvbox_contrast_light = 'soft'
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_termcolors = 0
let g:gruvbox_sign_column = 'bg1'
let g:gruvbox_color_column = 'bg1'

" /gruvbox config }}}

" For running linters asyncronously
Plug 'dense-analysis/ale'
" ale config {{{
let g:ale_echo_msg_format = '[%severity% %linter% %code%]: %s'
let g:ale_linters = {'python': ['flake8']}
if g:filwie#enable_glyphs
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

Plug 'junegunn/fzf', { 'dir': g:filwie#vimplug_plugin_directory . '/fzf', 'do': './install --bin'}
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

augroup fzf_window_tweak
  autocmd! FileType fzf
  autocmd  FileType fzf set noshowmode noruler laststatus=0
        \| autocmd BufLeave <buffer> set showmode ruler laststatus=0
augroup END

if has('nvim')
  let $FZF_DEFAULT_OPTS .= ' --border --margin=0,2 --reverse'
  let $FZF_DEFAULT_OPTS .= ' --color bg:' . g:colors#palette['dark0'] . ',bg+:' . g:colors#palette['dark1']
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
      \ 'coc-solargraph',
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
if g:filwie#enable_glyphs
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

if g:filwie#enable_glyphs
  Plug 'ryanoasis/vim-devicons'
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
  " vim-devicons config {{{
  let g:webdevicons_enable = g:filwie#enable_glyphs
  let g:DevIconsEnableFoldersOpenClose = 1
  " /vim-devicons config }}}
endif

Plug 'liuchengxu/vista.vim', { 'on': 'Vista' }
" vista config {{{
nnoremap <F8> :Vista<CR>

let g:vista#renderer#enable_icon = g:filwie#enable_glyphs
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
if g:filwie#enable_glyphs
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
function! LastStatusToggle() abort
  if &laststatus == 0 || &laststatus == 1
    set laststatus=2
  else
    set laststatus=0
  endif
endfunction
set autochdir
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
set updatetime=300  " smaller updatetime for CursorHold & CursorHoldI
if has('clipboard')
  nnoremap y "+y
  vnoremap y "+y
  set clipboard=unnamedplus
endif
set undofile
set undodir=$XDG_DATA_HOME/nvim/undo
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
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
augroup termoptions
  autocmd!
  autocmd TermOpen * setlocal nonumber norelativenumber bufhidden=hide
augroup END
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
silent! colorscheme gruvbox






function! s:hifg(group, bg, fg)
  " Arguments: group, guibg, guifg
  let l:hl = ['highlight ', a:group,
        \ 'guibg=' . a:bg,
        \ 'guifg=' . a:fg ]

  execute join(l:hl, ' ')
endfunction

if &background ==# 'dark'
  call s:hifg('Normal', 'NONE', g:colors#palette['light0_hard'])
  call s:hifg('SignColumn', 'NONE', g:colors#palette['light0'])
  call s:hifg('ColorColumn','NONE', g:colors#palette['bright_orange'])
  call s:hifg('LineNr', 'NONE', g:colors#palette['dark2'])
  call s:hifg('CursorLineNr', 'NONE',  g:colors#palette['light2'])
  call s:hifg('Folded', 'NONE', g:colors#palette['dark2'])

  call s:hifg('EndOfBuffer', 'NONE',  g:colors#palette['dark0_hard'])
  call s:hifg('VertSplit', 'NONE',  g:colors#palette['dark1'])

  call s:hifg('ALEErrorSign', 'NONE',  g:colors#palette['bright_red'])
  call s:hifg('ALEWarningSign', 'NONE',  g:colors#palette['bright_yellow'])

  call s:hifg('GitGutterAdd', 'NONE',  g:colors#palette['faded_green'])
  call s:hifg('GitGutterChange', 'NONE',  g:colors#palette['faded_yellow'])
  call s:hifg('GitGutterDelete', 'NONE',  g:colors#palette['faded_red'])
  execute 'highlight CursorLine guibg=' . g:colors#palette['dark0']
else
  call s:hifg('Normal', 'NONE', g:colors#palette['dark0_soft'])
  call s:hifg('SignColumn', 'NONE', g:colors#palette['dark0_soft'])
  call s:hifg('ColorColumn','NONE', g:colors#palette['faded_orange'])
  call s:hifg('LineNr', 'NONE', g:colors#palette['light2'])
  call s:hifg('CursorLine', g:colors#palette['light2'], 'NONE')
  call s:hifg('CursorLineNr', 'NONE',  g:colors#palette['dark2'])
  call s:hifg('Folded', 'NONE', g:colors#palette['dark2'])

  call s:hifg('EndOfBuffer', 'NONE',  g:colors#palette['dark0_hard'])
  call s:hifg('VertSplit', 'NONE',  g:colors#palette['dark1'])

  call s:hifg('ALEErrorSign', 'NONE',  g:colors#palette['faded_red'])
  call s:hifg('ALEWarningSign', 'NONE',  g:colors#palette['faded_yellow'])

  call s:hifg('GitGutterAdd', 'NONE',  g:colors#palette['faded_green'])
  call s:hifg('GitGutterChange', 'NONE',  g:colors#palette['faded_yellow'])
  call s:hifg('GitGutterDelete', 'NONE',  g:colors#palette['faded_red'])
  execute 'highlight CursorLine guibg=' . g:colors#palette['dark0']
endif

highlight link GitGutterChangeDelete GitGutterChange
highlight Comment cterm=italic  gui=italic
" /theme }}}
