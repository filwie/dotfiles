#!/usr/bin/env python3
import argparse
import json
from pathlib import Path
import sys


def handle_args():
    parser = argparse.ArgumentParser(description='List packages for given package manager.')
    parser.add_argument('pm', metavar='<package manager>', type=str,
                        help='package manager to list packages for')
    return parser.parse_args()


if __name__ == '__main__':
    args = handle_args()
    packages_file = Path(__file__).parent / 'packages.json'
    packages = json.loads(packages_file.read_text())
    available_package_managers = packages.keys()
    if args.pm not in available_package_managers:
        print(f'Specified package manager ({args.pm}) not found in {list(available_package_managers)}.')
        sys.exit(1)
    print(' '.join(packages[args.pm]))
