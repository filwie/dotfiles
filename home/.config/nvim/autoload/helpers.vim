" vim: set ft=vim sw=2 ts=2:
function! helpers#EnsureVimPlugIsInstalled(url, dest) abort
  let l:vimplug_download_url = a:url
  let l:vimplug_install_path = a:dest

  if empty(glob(l:vimplug_install_path))
    echo 'Installing VimPlug'
    execute '!curl --create-dirs -fLo ' . l:vimplug_install_path  l:vimplug_download_url
    echo 'Installing plugins'

    augroup VimPlugInstall
      autocmd!
      autocmd VimEnter * PlugInstall --sync
    augroup END
    source $MYVIMRC
  endif


endfunction
