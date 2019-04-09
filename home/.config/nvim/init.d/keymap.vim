let g:user_mapping_run = '<F10>'
let g:user_mapping_build = '<F9>'

let g:user_mapping_fmt = '<leader>8'
let g:user_mapping_test = '<leader>te'

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
" Emacs
map <C-g> <Esc><Esc>
