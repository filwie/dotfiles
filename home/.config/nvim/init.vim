" vim: set ts=2 sw=2 fdm=marker:
scriptencoding utf-8
if $VIM_SHELL ==# '' | set shell=$VIM_SHELL | endif
source ~/.config/nvim/init.d/helpers.vim

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
" }}}"

Plug 'sheerun/vim-polyglot'
" vim-polyglot config {{{
augroup CustomFileTypes
  autocmd BufRead,BufNewFile */ansible/*.yml set filetype=yaml.ansible
augroup END
let g:polyglot_disabled = ['markdown']
" /vim-polyglot config }}}

Plug 'tpope/vim-markdown'
" vim-markdown config
augroup MarkdownCodeBlocks
autocmd FileType markdown
  \ let g:markdown_fenced_languages = ['make', 'zsh', 'sh',  'help', 'json', 'tex',
                                     \ 'sql', 'ruby', 'jinja', 'html', 'css',
                                     \ 'yaml', 'ansible', 'lua', 'vim', 'java',
                                     \ 'python', 'javascript', 'xhtml', 'xml', 'c', 'cpp']
augroup END
"

Plug 'skywind3000/asyncrun.vim'

if g:fzf_path != '' | Plug g:fzf_path | endif
Plug 'junegunn/fzf.vim'
" fzf config {{{
nnoremap <C-p> :FZF<CR>
nnoremap <C-t> :GFiles<CR>

nnoremap <leader>p :Commands<CR>
nnoremap <leader>t :Tags<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>g :Rg<CR>
" /fzf config }}}

Plug 'morhetz/gruvbox'

" go {{{
Plug 'stamblerre/gocode', { 'rtp': 'nvim', 'do': '~/.local/share/nvim/plugged/gocode/nvim/symlink.sh' }
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
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

Plug 'neoclide/coc.nvim', {'do': './install.sh nightly'}
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
let g:vista_default_executive = 'ctags'
let g:vista_fzf_preview = ['right:50%']
let g:vista_executive_for = {
  \ 'go': 'ctags',
  \ 'javascript': 'coc',
  \ 'javascript.jsx': 'coc',
  \ 'python': 'coc',
\ }
" /vista config }}}

Plug 'tpope/vim-surround'

Plug 'ludovicchabant/vim-gutentags'

call plug#end()
" /PLUGIN LIST }}}

source ~/.config/nvim/init.d/general.vim
source ~/.config/nvim/init.d/theme.vim
source ~/.config/nvim/init.d/keymap.vim
source ~/.config/nvim/init.d/filetype.vim
