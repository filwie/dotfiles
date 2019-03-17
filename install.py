#!/usr/bin/env python3
from pathlib import Path
import json
import logging
import sys
import platform

LOG = logging.getLogger('mini-dotfiles')
logging.basicConfig(level=logging.INFO)

try:
    script_path = Path(__file__)
    script_path = script_path.resolve()
except NameError as err:
    LOG.error('Unable to determine script path. (%s)', err)
    sys.exit(1)


REAL_HOME = Path.home()
REPO_HOME = script_path.parent / 'home'
LOG.info(f'Repository home path set to: {REPO_HOME}')


class Dotfile():
    def __init__(self, src_path: Path):
        self.src_path = src_path

    @property
    def real(self) -> Path:
        return self.src_path.resolve()

    @property
    def relative_to_repo_home(self) -> Path:
        return self.src_path.relative_to(REPO_HOME)

    @property
    def destination(self) -> Path:
        return REAL_HOME / self.relative_to_repo_home


def list_available_dotfiles():
    pass


def detect_os():
    platform.system()
    platform.platform()
    platform.release()


if __name__ == '__main__':
    logging.basicConfig()
