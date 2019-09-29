" vim: set ts=2 sw=2 fdm=marker:
scriptencoding utf-8
if $VIM_SHELL ==# '' | set shell=$VIM_SHELL | endif

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

" plugin-variables {{{
let g:fzf_path = ''
for fzf_path in ['$FZF_BASE', '~/.fzf', '/usr/share/fzf', '/usr/local/opt/fzf']
  if !empty(glob(fzf_path)) | let g:fzf_path = fzf_path | break | endif
endfor
" plugin-variables }}}

" plugins {{{
let g:nvim_plugin_dir = '~/.local/share/nvim/plugged'
call plug#begin(g:nvim_plugin_dir)

Plug 'w0rp/ale'  " {{{
let g:ale_echo_msg_format = '[%severity% %linter% %code%]: %s'
let g:ale_linters = {'python': ['flake8']}
let g:ale_sign_error = 'er'
let g:ale_sign_warning = 'wa'
" }}}"

Plug 'sheerun/vim-polyglot'
" vim-polyglot config {{{
augroup CustomFileTypes
  autocmd BufRead,BufNewFile */ansible/*.yml set filetype=yaml.ansible
augroup END
let g:polyglot_disabled = ['markdown']
" /vim-polyglot config }}}

Plug 'tpope/vim-markdown'
" vim-markdown config {{{
augroup MarkdownCodeBlocks
autocmd FileType markdown
  \ let g:markdown_fenced_languages = ['make', 'zsh', 'sh',  'help', 'json', 'tex',
                                     \ 'sql', 'ruby', 'jinja', 'html', 'css',
                                     \ 'yaml', 'ansible', 'lua', 'vim', 'java',
                                     \ 'python', 'javascript', 'xhtml', 'xml', 'c', 'cpp']
augroup END
" /vim-markdown config }}}

if g:fzf_path != '' | Plug g:fzf_path | endif
Plug 'junegunn/fzf.vim'
" fzf config {{{
nnoremap <C-p> :FZF<CR>
nnoremap <C-t> :GFiles<CR>

nnoremap <leader>p :Commands<CR>
nnoremap <leader>m :Marks<CR>
nnoremap <leader>l :Lines<CR>
nnoremap <leader>t :Tags<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>g :Rg<CR>
" /fzf config }}}

Plug 'morhetz/gruvbox'

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
let g:coc_global_extensions = ['coc-git', 'coc-pairs', 'coc-highlight', 'coc-lists', 'coc-yank',
      \ 'coc-tabnine',
      \ 'coc-yaml',
      \ 'coc-rls', 'coc-python', 'coc-vimlsp', 'coc-tsserver', 'coc-gocode',
      \ 'coc-html', 'coc-css']

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

Plug 'valloric/MatchTagAlways'

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
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'currentfunction', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status',
      \   'currentfunction': 'CocCurrentFunction'
      \ },
      \ }
" /lightline config }}}

Plug 'mhinz/vim-startify'
" vim-startify config {{{
let g:startify_custom_header = ''
let g:startify_custom_footer = ''
" /vim-startify config }}}

Plug 'liuchengxu/vista.vim'
" vista config {{{
nnoremap <F8> :Vista<CR>
let g:vista#renderer#enable_icon = 0
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

Plug 'yuttie/comfortable-motion.vim'
" comfortable motion config {{{
nnoremap <silent> <C-j> :call comfortable_motion#flick(40)<CR>
nnoremap <silent> <C-k> :call comfortable_motion#flick(-40)<CR>
let g:comfortable_motion_no_default_key_mappings = 1
let g:BASH_Ctrl_j = 'off'
let g:BASH_Ctrl_k = 'off'
noremap <silent> <ScrollWheelDown> :call comfortable_motion#flick(40)<CR>
noremap <silent> <ScrollWheelUp>   :call comfortable_motion#flick(-40)<CR>
" }}}

call plug#end()
" /PLUGIN LIST }}}

" general settings {{{
filetype plugin indent on
set diffopt+=vertical
set laststatus=1
set foldmethod=marker
set hlsearch
set tabstop=4 softtabstop=4 expandtab shiftwidth=4 " autoindent copyindent
set textwidth=0 wrapmargin=0 " dont break lines automatically
set number
set hidden
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
set fillchars+=vert:\│
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
tnoremap <C-x> :bprevous<CR>
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
call FileTypeMap(['python'], ':term python %', ':Autopep8', ':term pytest')
call FileTypeMap(['bash', 'sh'], ':term./%')
call FileTypeMap(['rust'], ':RustRun', ':RustFmt', ':RustTestterm')
call FileTypeMap(['java'], ':term javac % && java run %:r', s:_nm, s:_nm, ':term javac %')
call FileTypeMap(['go'], ':GoRun', ':GoFmt', ':GoTest')
call FileTypeMap(['json'], s:_nm, ':%termpython -m json.tool')
call FileTypeMap(['ansible', 'ansible.yaml', 'yaml.ansible'], ':term ansible-playbook %')
call FileTypeMap(['vim'], ':source %')
call FileTypeMap(['markdown'], ':call MarkdownConvertOpen()')
" /filetype specific config }}}

" theme {{{
set background=dark
let g:gruvbox_italic = 1
let g:gruvbox_contrast_light = 'hard'
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

call s:hifg('GitAdd', 'NONE',  s:faded_green)
call s:hifg('GitChange', 'NONE',  s:faded_yellow)
call s:hifg('GitDelete', 'NONE',  s:faded_red)

highlight link GitChangeDelete GitChange

highlight Comment cterm=italic  gui=italic
execute 'highlight CursorLine guibg=' . s:dark0
" /theme }}}
