" vim: set ft=vim sw=2 ts=2:
function! helpers#EnsureVimPlugIsInstalled(url, dest) abort
  if empty(glob(a:dest))
    echo 'Installing VimPlug'
    execute '!curl --create-dirs -fLo ' . a:dest . ' ' . a:url
    echo 'Installing plugins'

    augroup vim_plug_install
      autocmd!
      autocmd VimEnter * PlugInstall --sync
    augroup END
    source $MYVIMRC
  endif
endfunction

function! helpers#FormatJSON()  abort
  execute ':%!python -m json.tool'
endfunction

function! helpers#MarkdownConvertOpen() abort
  let l:outfile = expand('/tmp/%:t:r.html')

  let l:_open_command = ['xdg-open', 'open'][has('macunix')]
  let l:open = l:_open_command . ' ' . l:outfile
  let l:export = '!grip % --export ' . l:outfile

  if ! executable('grip')
    echoerr 'grip not found. Run: pip install --user grip'
    return
  endif

  " do not use terminal browser
  let $DISPLAY = ':0.0'
  execute l:export . ' && ' . l:open
endfunction

function! helpers#PaletteHighlight(hlgroup, bg, fg_dark, fg_light) abort
  if empty(g:colors#palette)
    echom 'Global variable g:colors#palette is not set correctly'
  endif

  let l:bg_hex = get(g:colors#palette, a:bg, 'NONE')
  let l:fg_hex = get(g:colors#palette,
        \ {'light': a:fg_light, 'dark': a:fg_dark}[&background],
        \ 'NONE')

  execute 'highlight ' . a:hlgroup . ' guibg=' . l:bg_hex . ' guifg=' . l:fg_hex
endfunction
