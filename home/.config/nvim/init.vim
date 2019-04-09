scriptencoding utf-8
if $VIM_SHELL ==# '' | set shell=$VIM_SHELL | endif

source ~/.config/nvim/init.d/helpers.vim

call InstallVimPlug()

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
Plug 'stamblerre/gocode', { 'rtp': 'nvim', 'do': '~/.local/share/nvim/plugged/gocode/nvim/symlink.sh' }
Plug 'deoplete-plugins/deoplete-go', {'do': 'make'}
Plug 'deoplete-plugins/deoplete-jedi', {'for': ['python']}
Plug 'artur-shaik/vim-javacomplete2', {'for': ['java']}
Plug 'racer-rust/vim-racer', {'for': ['rust']}
Plug 'valloric/MatchTagAlways', {'for': g:tag_languages}
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'vim-python/python-syntax'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'srcery-colors/srcery-vim'
Plug 'ervandew/supertab'
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
let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']

" Deoplete - java
let g:JavaComplete_Home = $HOME . '/.local/share/nvim/plugged/vim-javacomplete2/libs/javavi'
let $CLASSPATH .= '.:' . $HOME . '/.local/share/nvim/plugged/vim-javacomplete2/libs/javavi/target/classes'

" NERDTree
" let g:NERDTreeDirArrowExpandable = ' '
" let g:NERDTreeDirArrowCollapsible = ' ﱮ'
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

source ~/.config/nvim/init.d/general.vim
source ~/.config/nvim/init.d/keymap.vim
source ~/.config/nvim/init.d/filetype.vim
source ~/.config/nvim/init.d/interface.vim
source ~/.config/nvim/init.d/gvim.vim
