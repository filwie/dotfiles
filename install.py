#!/usr/bin/env python3
from pathlib import Path
import json
import logging
import sys
import platform

LOG = logging.getLogger('mini-dotfiles')
logging.basicConfig()

try:
    script_path = Path(__file__)
    PROJECT_ROOT = script_path.parent.resolve()
except NameError as err:
    LOG.error('Unable to determine script path. (%s)', err)
    sys.exit(1)

PACKAGE_LIST_FILE = PROJECT_ROOT / 'packages' / 'packages.json'
XDG_CONFIGS = PROJECT_ROOT / 'home' / 'config'


def parse_package_list(package_list_file: Path = PACKAGE_LIST_FILE) -> dict:
    packages = json.loads(package_list_file.read_text())
    return packages


def detect_os():
    platform.system()
    platform.platform()
    platform.release()


def link_dotfiles():
    script_path = Path(__file__).resolve()
    dotfiles_root_dir = script_path.parent

    dotfiles_config_dir = dotfiles_root_dir / 'home' / 'config'

    for conf_subdir in dotfiles_config_dir.iterdir():
        print(conf_subdir)


if __name__ == '__main__':
    parse_package_list()
