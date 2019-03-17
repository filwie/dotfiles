import json
from pathlib import Path

packages_list = Path(__file__).parent / 'packages.json'
packages = json.loads(packages_list.read_text())

categories = packages.keys()

if __name__ == '__main__':
    print(categories)
