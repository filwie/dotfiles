#!/usr/bin/env python3

import sys
from os import environ
from pathlib import Path

try:
    script_path = Path(__file__)
    script_path = script_path.resolve()
except NameError as err:
    print('Unable to determine script path:', err, file=sys.stderr)
    sys.exit(1)

HOME = Path.home()
XDG_CONFIG_HOME = Path(environ.get('XDG_CONFIG_HOME', f'{HOME}/.config'))
REPO_HOME = script_path.parent / 'home'
REPO_XDG_CONFIG_HOME = REPO_HOME / '.config'

if __name__ == '__main__':
    home_dotfiles = REPO_HOME.glob('*[!.config]*')
    xdg_dotfiles = REPO_XDG_CONFIG_HOME.glob('*')

    src_dest_map = {}

    for dotfile in home_dotfiles:
        src_dest_map.update({dotfile: HOME / dotfile.relative_to(REPO_HOME)})

    for dotfile in xdg_dotfiles:
        src_dest_map.update({dotfile: XDG_CONFIG_HOME / dotfile.relative_to(REPO_XDG_CONFIG_HOME)})

    for src, dest in src_dest_map.items():
        print(f'{src} -> {dest}')
