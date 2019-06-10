scriptencoding utf-8
if $VIM_SHELL ==# '' | set shell=$VIM_SHELL | endif

source ~/.config/nvim/init.d/helpers.vim

call InstallVimPlug()

" PLUGIN VARIABLES {{{
let g:ctags_supported_languages = ['ansible', 'assembler', 'awk', 'bash', 'c', 'cpp', 'erlang', 'fortran', 'html', 'java', 'javascript', 'lisp', 'lua', 'make', 'matlab', 'pascal', 'perl', 'php', 'sql', 'python', 'rexx', 'ruby', 'scheme', 'sh', 'tcl', 'tex', 'vim', 'vimscript', 'yacc', 'yaml', 'zsh']
let g:languages_to_lint = ['python', 'css', 'html', 'java', 'c', 'cpp', 'yaml', 'ansible', 'markdown', 'rust', 'vim']
let g:tag_languages = ['html', 'xml', 'xhtml', 'jinja']
" /PLUGIN VARIABLES}}}

" PLUGINS LIST {{{
" Sorted alphabetically by plugin name `sort i /^\(Plug.*\/\|Plug.*\$\)/`
if has('nvim')
    call plug#begin('~/.local/share/nvim/plugged')
else
    call plug#begin('~/.vim/plugged')
endif
if ! has('nvim')  " used by Shougo plugins
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif

Plug 'w0rp/ale', {'for': g:languages_to_lint}
Plug 'pearofducks/ansible-vim'
Plug 'skywind3000/asyncrun.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'ekalinin/Dockerfile.vim'
Plug $FZF_BASE
Plug 'junegunn/fzf.vim'
Plug 'morhetz/gruvbox'
Plug 'mboughaba/i3config.vim'
Plug 'neoclide/coc.nvim', {'do': './install.sh nightly'}
Plug 'Shougo/denite.nvim', {'do': function('UpdateRP')}
Plug 'stamblerre/gocode', { 'rtp': 'nvim', 'do': '~/.local/share/nvim/plugged/gocode/nvim/symlink.sh' }
Plug 'racer-rust/vim-racer', {'for': ['rust']}
Plug 'rust-lang/rust.vim'
Plug 'valloric/MatchTagAlways', {'for': g:tag_languages}
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'vim-python/python-syntax'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'srcery-colors/srcery-vim'
Plug 'ervandew/supertab'
Plug 'itchyny/lightline.vim'
Plug 'mhinz/vim-startify'
Plug 'liuchengxu/vista.vim'
Plug 'tell-k/vim-autopep8', {'for': 'python'}
Plug 'rhysd/vim-clang-format', {'for': ['c', 'cpp']}
Plug 'ap/vim-css-color'
Plug 'jiangmiao/auto-pairs'
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
Plug 'Yggdroot/indentLine'
call plug#end()
" /PLUGIN LIST }}}

" PLUGIN SETTINGS {{{
" Ale
let g:ale_echo_msg_format = '[%severity% %linter% %code%]: %s'

" Autopep8
let g:autopep8_disable_show_diff=0
let g:autopep8_ignore='E501'  " ignore specific PEP8 (line too long,)

" Autopairs
let g:AutoPairsShortcutToggle = '<leader>ap'

" Coc
function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction



" FZF colors {{{
let g:fzf_colors = { 'fg':      ['fg', 'Normal'],
            \ 'bg':      ['bg', 'Normal'],
            \ 'hl':      ['fg', 'Comment'],
            \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
            \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
            \ 'hl+':     ['fg', 'Statement'],
            \ 'info':    ['fg', 'PreProc'],
            \ 'prompt':  ['fg', 'Conditional'],
            \ 'pointer': ['fg', 'Exception'],
            \ 'marker':  ['fg', 'Keyword'],
            \ 'spinner': ['fg', 'Label'],
            \ 'header': ['fg', 'Comment'] }
" /FZF }}}

" GitGutter
autocmd BufWritePost * GitGutter
let g:gitgutter_override_sign_column_highlight = 0

" indentLine
let g:indentLine_char = '│'
let g:indentLine_enabled = 1

" lightline
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

" NERDTree, WebDevIcons  {{{
let NERDTreeDirArrowExpandable = "\u00a0"
let NERDTreeDirArrowCollapsible = "\u00a0"
let g:NERDTreeDirArrows=0
let g:NERDTreeMouseMode=3

let g:WebDevIconsNerdTreeAfterGlyphPadding = '  '
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1
" by pattern:
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols = {} " needed
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['Dockerfile'] = ''
" by extension:
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {} " needed
" /NerdTree }}}

" Python-syntax
let g:python_highlight_all = 1

" Supertab
let g:SuperTabDefaultCompletionType = '<c-n>'

" Startify
let g:startify_custom_header = ''
let g:startify_custom_footer = ''

" toggle quickfix window
nnoremap <leader>q :call asyncrun#quickfix_toggle(6)<CR>

" Wintabs
let g:wintabs_ui_modified = ' (m)'
let g:wintabs_ui_readonly = ' (ro)'
let g:wintabs_ui_sep_leftmost = ''
let g:wintabs_ui_sep_inbetween = ''
let g:wintabs_ui_sep_rightmost = ''

" vista.vim
function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

set statusline+=%{NearestMethodOrFunction()}
autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

" /PLUGIN SETTINGS }}}

source ~/.config/nvim/init.d/general.vim
source ~/.config/nvim/init.d/keymap.vim
source ~/.config/nvim/init.d/filetype.vim
source ~/.config/nvim/init.d/interface.vim
source ~/.config/nvim/init.d/gvim.vim
