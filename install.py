#!/usr/bin/env python3

import argparse
from enum import Enum
import sys
from os import environ
from pathlib import Path
from typing import Dict, List
import time


def handle_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description='Link dotfiles.')
    parser.add_argument('-l', '--list', action='store_true', default=False,
                        help='only list available dotfiles')
    parser.add_argument('dotfiles', metavar='DOTFILE', nargs='*', type=str, default=['all'],
                        help='one or more dotfiles to link (default: all)')
    return parser.parse_args()


LinkResult = Enum('LinkResult', 'NOT_TOUCHED CREATED EXISTING BACKED_UP OVERWRITTEN IGNORED')


class Dotfile:
    str_template = '{: <20} | {: <20}'

    def __init__(self, src: Path, dest: Path):
        self.src = src
        self.dest = dest
        self.state = LinkResult.NOT_TOUCHED

    @property
    def name(self):
        return self.src.stem.strip('.').lower()

    @property
    def rename_suffix(self):
        return f'.bak.{int(time.time())}'

    def link(self):
        renamed = False
        if self.dest.exists():
            if self.dest.samefile(self.src):
                self.state = LinkResult.EXISTING
                return
            else:
                self.dest.rename(f'{self.dest}{self.rename_suffix}')
                renamed = True
        self.dest.symlink_to(self.src)
        self.state = LinkResult.CREATED if not renamed else LinkResult.BACKED_UP

    def __str__(self):
        return Dotfile.str_template.format(self.name, self.state.name.lower(), self.src, self.dest)


class DotfileMap:
    exclude_glob = '*[!.config]*'

    def __init__(self, src_dest_dirs: Dict[Path, Path]):
        self.dotfiles = []
        self.results = {}
        for src_dir, dest_dir in src_dest_dirs.items():
            self._register(src_dir, dest_dir)

    def _register(self, src_dir: Path, dest_dir: Path):
        for src in src_dir.glob(DotfileMap.exclude_glob):
            self.dotfiles.append(Dotfile(src, dest_dir / src.relative_to(src_dir)))

    def link_one(self, dotfile: Dotfile):
        self.results.update({dotfile: dotfile.link()})

    def link_some(self, dotfiles: List[Dotfile]):
        for dotfile in dotfiles:
            self.link_one(dotfile)

    def link_all(self): self.link_some(self.dotfiles)

    def __str__(self):
        return '\n'.join(str(d) for d in self.dotfiles)


if __name__ == '__main__':
    try:
        repo_root = Path(__file__).parent.resolve()
    except (NameError, FileNotFoundError) as err:
        print('Unable to determine repo root.', err, file=sys.stderr)
        sys.exit(1)

    home = Path.home()
    repo_home = repo_root / 'home'

    xdg_config_home = Path(environ.get('XDG_CONFIG_HOME', f'{home}/.config'))
    xdg_config_home.mkdir(exist_ok=True)
    repo_xdg_config_home = repo_home / '.config'

    args = handle_args()

    dm = DotfileMap({
        repo_home: home,
        repo_xdg_config_home: xdg_config_home
    })

    if args.list:
        print('Available dotfiles: {}'.format(' '.join(d.name for d in dm.dotfiles)))
    elif 'all' in args.dotfiles:
        dm.link_all()
    else:
        dm.link_some(filter(lambda d: d.name in args.dotfiles, dm.dotfiles))
