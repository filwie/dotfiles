import argparse
import json
from pathlib import Path


def handle_args():
    parser = argparse.ArgumentParser(description='List packages for given package manager.')
    parser.add_argument('package_managers', metavar='package mangaer', type=str, nargs='+',
                        help='package manager to list packages for')
    return parser.parse_args()


if __name__ == '__main__':
    args = handle_args()
    package_managers = args.package_managers
    packages_list_file_path = Path(__file__).parent / 'packages.json'
    packages = json.loads(packages_list.read_text())
    print(package_managers)
