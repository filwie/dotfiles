" vim: set ts=2 sw=2 fdm=marker:
set encoding=utf-8
scriptencoding utf-8

let $XDG_DATA_HOME = $HOME . '/.local/share/'
let $THEME_ENABLE_GLYPHS = 1
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1

let g:data_dir = stdpath('data')
let g:conf_dir = stdpath('config')
let g:autoload_dir = g:data_dir . '/site/autoload'
let g:undo_dir = g:data_dir . './undo'
let $UNDODIR = g:undo_dir

let g:enable_glyphs = get(environ(), 'THEME_ENABLE_GLYPHS', 0) ==# 1
let g:python_interpreter = get(environ(), 'PYTHON_INTERPRETER', 'python')


" plugins {{{
let g:plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
let g:plug_path =  g:autoload_dir . '/plug.vim'
let g:plug_dir = g:data_dir . '/plugged'
if empty(glob(g:plug_path))
  echoerr 'Plugin manager missing: ' . g:plug_url . ' -> ' . g:plug_path
end

call plug#begin(g:plug_dir)
" Plug 'tpope/vim-scriptease', {'on': 'PP'}
" " vim-scriptease config {{{
" command! -nargs=0 REPL :PP
" " /vim-scriptease config }}}

Plug 'tpope/vim-commentary'

"Plug 'morhetz/gruvbox'
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
let g:ale_linters = {'python': ['flake8', 'pylint]']}
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
        \ 'sql', 'ruby', 'html', 'css',
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

" Plug 'junegunn/goyo.vim', {'on': 'Goyo'}
" " goyo.vim config {{{
" augroup goyou_fix_hlgroups
"   autocmd!
"   autocmd User GoyoLeave silent! source $MYVIMRC
" augroup END
" " / goyo.vim config }}}

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
" vim-go config {{{
let g:go_code_completion_enabled = 0
" / vim-go config }}}

" Plug 'racer-rust/vim-racer'
" Plug 'rust-lang/rust.vim'

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
"
" Plug 'valloric/MatchTagAlways', {'for': ['jinja', 'html']}

" Plug 'terryma/vim-multiple-cursors'
" " vim-multiple-cursors config {{{
" let g:multi_cursor_use_default_mapping=0
" let g:multi_cursor_start_word_key      = '<C-d>'
" let g:multi_cursor_select_all_word_key = '<A-n>'
" let g:multi_cursor_start_key           = 'g<C-n>'
" let g:multi_cursor_select_all_key      = 'g<A-n>'
" let g:multi_cursor_next_key            = '<C-d>'
" let g:multi_cursor_prev_key            = '<C-p>'
" let g:multi_cursor_skip_key            = '<C-x>'
" let g:multi_cursor_quit_key            = '<Esc>'
" " /vim-multiple-cursors config }}}

" Plug 'itchyny/lightline.vim'
" " lightline config {{{
" function! CocCurrentFunction()
"   return get(b:, 'coc_current_function', '')
" endfunction
" function! LightlineGitBlame() abort
"   let blame = get(b:, 'coc_git_blame', '')
"   " return blame
"   return winwidth(0) > 120 ? blame : ''
" endfunction
" let g:lightline = {
"       \ 'colorscheme': 'gruvbox',
"       \ 'active': {
"       \   'left': [
"       \     [ 'mode', 'paste' ],
"       \     [ 'cocstatus', 'currentfunction', 'readonly', 'filename', 'modified' ]
"       \   ],
"       \   'right':[
"       \     [ 'filetype', 'fileencoding', 'blame', 'percent' ],
"       \     [ 'lineinfo' ]
"       \   ],
"       \ },
"       \ 'component_function': {
"       \   'cocstatus': 'coc#status',
"       \   'currentfunction': 'CocCurrentFunction',
"       \   'blame': 'LightlineGitBlame'
"       \ },
"       \ }
" " /lightline config }}}

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

Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

" Plug 'ludovicchabant/vim-gutentags'

Plug 'airblade/vim-gitgutter'
" vim-gitgutter config {{{
let g:gitgutter_sign_added =              ['█ ', ' '][g:enable_glyphs]
let g:gitgutter_sign_modified =           ['█ ', ' '][g:enable_glyphs]
let g:gitgutter_sign_removed =            ['█ ', ' '][g:enable_glyphs]
let g:gitgutter_sign_removed_first_line = ['█ ', ' '][g:enable_glyphs]
let g:gitgutter_sign_modified_removed =   ['█ ', ' '][g:enable_glyphs]
" /vim-gitgutter config }}}

" Plug 'lmeijvogel/vim-yaml-helper', { 'for': 'yaml' }
" " vim-yaml-helper config {{{
" let g:vim_yaml_helper#auto_display_path = 0
" function! YamlPathYank()
"   if &filetype !=# 'yaml'
"     echo 'Not a yaml file'
"     return 1
"   endif
"   redir @a
"   :YamlDisplayFullPath
"   redir END

"   normal! f:
"   normal! "Ay$
" endfunction

" augroup YamlPluginMapping
"   autocmd FileType yaml nnoremap <F3> :call YamlPathYank() <CR>
" augroup END

" nnoremap <leader>a "ap
" nnoremap <leader>* *<C-O>:%s///gn<CR>
" " /vim-yaml-helper config }}}

" Plug 'godlygeek/tabular'

call plug#end()
" /PLUGIN LIST }}}

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
set clipboard+=unnamedplus
set undofile
set undodir=$UNDODIR
set undolevels=1000
set undoreload=10000
if has('persistent_undo')
  call system('mkdir ' . &undodir)
  set undofile
endif
" augroup relative_line_numbers
"   autocmd!
"   autocmd BufEnter,FocusGained,InsertLeave * if &modifiable | set relativenumber | endif
"   autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
" augroup END
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

command! -nargs=0 LastStatusToggle :let &laststatus = [2, 0, 0][&laststatus]
nnoremap <leader>s :LastStatusToggle<CR>
" /keymap }}}

" filetype specific confg {{{
let g:filetype_keymap = {
  \ 'run': '<F10>',
  \ 'fmt': '<leader>8',
  \ 'test': '<leader>te',
  \ 'build': '<F9>',
  \ }
let g:filetype_default_command = ':echom "Mapping is not specified"'
let g:filetype_commands = {
            \ 'ansible': {
            \   'run': ':term ansible-playbook %:p',
            \   },
            \ 'json': {
            \   'fmt': ':%!python -m json.tool',
            \   },
            \ 'markdown': {
            \   'run': ':call helpers#MarkdownConvertOpen()',
            \   },
            \ 'ruby': {
            \   'run': ':term ruby %:p',
            \   },
            \ 'python': {
            \   'run': ':term ' . g:python_interpreter . ' %:p',
            \   'fmt': ':%!autopep8 %:p',
            \   'test': ':term cd %:p:h && pytest',
            \   },
            \ 'sh': {
            \   'run': ':term %:p',
            \   },
            \ 'go': {
            \   'run': ':GoRun %',
            \   'fmt': ':GoFmt',
            \   'test': ':GoTest',
            \   'build': ':GoBuild',
            \   },
            \ 'rust': {
            \   'run': ':RustRun',
            \   'fmt': ':RustFmt',
            \   'test': ':GoTest',
            \   },
            \ 'vim': {
            \   'run': ':source %:p',
            \   },
            \ 'nim': {
            \   'run': ':source %',
            \   },
            \ }
let g:filetype_commands['bash'] = g:filetype_commands['sh']
let g:filetype_commands['fish'] = g:filetype_commands['sh']
let g:filetype_commands['yaml.ansible'] = g:filetype_commands['ansible']
let g:filetype_commands['ansible.yaml'] = g:filetype_commands['ansible']

for s:_filetype in keys(g:filetype_commands)
  for s:_command in keys(g:filetype_keymap)
    execute 'autocmd FileType ' . s:_filetype .
          \ ' nnoremap ' . g:filetype_keymap[s:_command] . ' ' .
          \ get(g:filetype_commands[s:_filetype], s:_command, g:filetype_default_command)
          \ . '<CR>'
    endfor
endfor
" /filetype specific config }}}

" theme {{{
let &background = 'dark'
silent! colorscheme gruvbox

highlight Normal guibg=NONE guifg=NONE

call helpers#PaletteHighlight('SignColumn', '', 'light0', 'dark0')
call helpers#PaletteHighlight('ColorColumn', '', 'bright_orange', 'faded_orange')

call helpers#PaletteHighlight('LineNr', '', 'dark4', 'light4')
call helpers#PaletteHighlight('CursorLineNr', '', 'bright_orange', 'faded_orange')
call helpers#PaletteHighlight('Folded', '', 'dark4', 'faded_orange')

call helpers#PaletteHighlight('EndOfBuffer', '', 'dark0_hard', 'light0_hard')
call helpers#PaletteHighlight('VertSplit', '', 'dark1', 'light1')

call helpers#PaletteHighlight('GitGutterAdd', '', 'neutral_green', 'neutral_green')
call helpers#PaletteHighlight('GitGutterChange', '', 'neutral_yellow', 'neutral_yellow')
call helpers#PaletteHighlight('GitGutterDelete', '', 'neutral_red', 'neutral_red')

call helpers#PaletteHighlight('ALEErrorSign', '', 'neutral_red', 'neutral_red')
call helpers#PaletteHighlight('ALEWarningSign', '', 'neutral_yellow', 'neutral_yellow')
call helpers#PaletteHighlight('ALEInfoSign', '', 'neutral_blue', 'neutral_blue')

highlight link GitGutterChangeDelete GitGutterChange
highlight Comment gui=italic
" /theme }}}
