function! NNOREMAP(keys, action)
    execute 'nnoremap <buffer> ' . a:keys . ' ' . a:action . '<CR>'
endfunction

function! FileTypePython()
    let l:run = ':term python3 %'
    let l:test = ':term pytest'
    let l:fmt = ':Autopep8'

    call NNOREMAP(g:user_mapping_run, l:run)
    call NNOREMAP(g:user_mapping_test, l:test)
    call NNOREMAP(g:user_mapping_fmt, l:fmt)
endfunction

function! FileTypeJava()
    let l:run = ':term javac % && java %:r'

    call NNOREMAP(g:user_mapping_run, l:run)
endfunction

function! FileTypeC()
    let l:run = ':term c run %'

    call NNOREMAP(g:user_mapping_run, l:run)
endfunction

function! FileTypeGo()
    let l:run = ':GoRun'
    let l:test = ':GoTest'
    let l:fmt = ':GoFmt'

    call NNOREMAP(g:user_mapping_run, l:run)
    call NNOREMAP(g:user_mapping_test, l:test)
    call NNOREMAP(g:user_mapping_fmt, l:fmt)
endfunction

function! FileTypeJson()
    let l:fmt = ':%!python -m json.tool'

    call NNOREMAP(g:user_mapping_fmt, l:fmt)
endfunction

function! FileTypeAnsible()
    nnoremap <buffer> <F9> :exec '!clear; ansible-playbook' shellescape(@%, 1)<CR>
endfunction

function! FileTypeVim()
    nnoremap <buffer> . g:user_mapping_run . :exec '!clear' <bar> source % <CR>
endfunction

function! MarkdownConvertOpen()  " {{{
    if has('macunix') | let l:open_html_cmd = 'open'
    else              | let l:open_html_cmd = 'xdg-open' | endif
    let l:cmd = ':AsyncRun grip $VIM_FILEPATH --export /tmp/$VIM_FILENOEXT.html && '
                \    . l:open_html_cmd . ' /tmp/$VIM_FILENOEXT.html'
    execute l:cmd
endfunction  " }}}

function! FileTypeMarkdown()
    let g:markdown_fenced_languages = ['make', 'zsh', 'sh', 'json', 'tex', 'sql', 'ruby', 'jinja', 'html', 'css', 'yaml', 'ansible', 'lua', 'vim', 'java', 'python', 'javascript', 'xhtml', 'xml', 'c', 'cpp']
    execute 'nnoremap <buffer> ' . g:user_mapping_run . ' :call MarkdownConvertOpen()<CR>'
endfunction

augroup FileTypeSpecific
    autocmd!
    autocmd FileType ansible, yaml, yaml.ansible call FileTypeAnsible()
    autocmd FileType c call FileTypeC()
    autocmd FileType go call FileTypeGo()
    autocmd FileType java call FileTypeJava()
    autocmd FileType markdown call FileTypeMarkdown()
    autocmd FileType python call FileTypePython()
    autocmd FileType vim call FileTypeVim()
    autocmd FileType json call FileTypeJson()

    autocmd BufWinEnter,WinEnter * if &buftype == 'terminal' | silent! normal i | endif
    autocmd BufRead,BufNewFile */ansible/*.yml set filetype=yaml.ansible
augroup END
