#!/usr/bin/env python3

import os
from pathlib import Path
from contextlib import contextmanager
import logging
import json
from glob import glob
import re
import argparse

LOG = logging.getLogger('dotfiles')


def handle_args():
    parser = argparse.ArgumentParser(
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
        description='Download Helm amd64 linux binary and create RPM distribution from it.'
    )

    parser.add_argument('-v', '--verbose', action='store_true',
                        help=f'Set logging level to INFO')

    parser.add_argument('-f', '--file', metavar='CONFIG_FILE',
                        default=Path(os.environ.get('DOTFILES_CONFIG_FILE', 'config.json')))

    return parser.parse_args()


@contextmanager
def pushd_popd(path: Path):
    initial_path = os.getcwd()
    try:
        os.chdir(path)
        yield
    except OSError:
        LOG.error('Could not enter specified directory: %s', path)
        raise
    finally:
        os.chdir(initial_path)


def is_already_symlinked(src, dest):
    if not dest.is_symlink():
        return False
    if dest.resolve().absolute() != src.absolute():
        return False
    return True


def read_config(path: Path):
    with path.open() as file:
        symlink_map = json.load(file)
    return symlink_map


def human_friendly_name(path: Path):
    pass


def symlink(src, dest: Path):
    pass


def main(args: argparse.Namespace):
    repo_root = Path(__file__).parent
    with pushd_popd(repo_root):
        config = read_config(args.file)

        for src_glob, dest_dir in config.items():
            dest_dir_path = Path(dest_dir)
            for src_path in map(Path, glob(src_glob)):
                src = src_path.absolute().expanduser()
                dest = dest_dir_path.expanduser() / src.name
                if is_already_symlinked(src, dest):
                    print(src.name, 'is already symlinked.')
                    continue
                # print(src.absolute())
                # print(dest.expanduser() / src.name)


if __name__ == '__main__':
    args = handle_args()
    main(args)
