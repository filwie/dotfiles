scriptencoding utf-8
if $VIM_SHELL ==# '' | set shell=$VIM_SHELL | endif

source ~/.config/nvim/init.d/helpers.vim

call InstallVimPlug()

" PLUGIN VARIABLES {{{
let g:ctags_supported_languages = ['ansible', 'assembler', 'awk', 'bash', 'c', 'cpp', 'erlang', 'fortran', 'html', 'java', 'javascript', 'lisp', 'lua', 'make', 'matlab', 'pascal', 'perl', 'php', 'sql', 'python', 'rexx', 'ruby', 'scheme', 'sh', 'tcl', 'tex', 'vim', 'vimscript', 'yacc', 'yaml', 'zsh']
let g:languages_to_lint = ['python', 'css', 'html', 'java', 'c', 'cpp', 'yaml', 'ansible', 'markdown', 'vim']
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
Plug 'ekalinin/Dockerfile.vim'
Plug $FZF_BASE
Plug 'junegunn/fzf.vim'
Plug 'morhetz/gruvbox'
Plug 'mboughaba/i3config.vim'
Plug 'Shougo/deoplete.nvim'
Plug 'Shougo/denite.nvim', {'do': 'UpdateRemotePlugins'}
Plug 'Shougo/deoplete-clangx', {'for': ['c', 'c++']}
Plug 'stamblerre/gocode', { 'rtp': 'nvim', 'do': '~/.local/share/nvim/plugged/gocode/nvim/symlink.sh' }
Plug 'deoplete-plugins/deoplete-go', {'do': 'make'}
Plug 'deoplete-plugins/deoplete-jedi', {'for': ['python']}
Plug 'racer-rust/vim-racer', {'for': ['rust']}
Plug 'valloric/MatchTagAlways', {'for': g:tag_languages}
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'vim-python/python-syntax'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'srcery-colors/srcery-vim'
Plug 'ervandew/supertab'
Plug 'mhinz/vim-startify'
Plug 'majutsushi/tagbar', {'for': g:ctags_supported_languages}
Plug 'tell-k/vim-autopep8', {'for': 'python'}
Plug 'rhysd/vim-clang-format', {'for': ['c', 'c++']}
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
call plug#end()
" /PLUGIN LIST }}}

" PLUGIN SETTINGS {{{
" Ale
let g:ale_echo_msg_format = '[%severity% %linter% %code%]: %s'

" Autopep8
let g:autopep8_disable_show_diff=0
let g:autopep8_ignore='E501'  " ignore specific PEP8 (line too long,)

" Deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']

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
" }}}

" Python-syntax
let g:python_highlight_all = 1

" Supertab
let g:SuperTabDefaultCompletionType = '<c-n>'

" Tagbar
let g:tagbar_type_ansible = {'ctagstype' : 'ansible', 'kinds' : ['t:tasks'], 'sort' : 0}

" toggle quickfix window
nnoremap <leader>q :call asyncrun#quickfix_toggle(6)<CR>

" Wintabs
let g:wintabs_ui_modified = ' (m)'
let g:wintabs_ui_readonly = ' (ro)'
let g:wintabs_ui_sep_leftmost = ''
let g:wintabs_ui_sep_inbetween = ''
let g:wintabs_ui_sep_rightmost = ''

" /PLUGIN SETTINGS }}}

source ~/.config/nvim/init.d/general.vim
source ~/.config/nvim/init.d/keymap.vim
source ~/.config/nvim/init.d/filetype.vim
source ~/.config/nvim/init.d/interface.vim
source ~/.config/nvim/init.d/gvim.vim
