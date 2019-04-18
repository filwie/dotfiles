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
