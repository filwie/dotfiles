#!/usr/bin/env python3
from collections import namedtuple
import sys
from pathlib import Path

try:
    import jinja2
except ImportError:
    print('Cannot import `jinja2`. Install it first.', file=sys.stderr)
    sys.exit(1)


docker_dir = Path(__file__).parent
dockerfile_template_file = docker_dir / 'Dockerfile.j2'
dockerfile_template = jinja2.Template(dockerfile_template_file.read_text())

Image = namedtuple('Image', ['base', 'tag', 'env', 'run_commands',
                             'package_manager', 'package_manager_argv', 'entrypoint'],
                   defaults=['latest', {}, [], '', [], 'fish'])

template_args = {
    'install_packages': ['fish', 'neovim', 'git', 'python3'],
    'install_sh_argv': ['fish'],
}

images = dict(
    arch=Image('archlinux/base',
               package_manager='pacman',
               package_manager_argv=['--noconfirm', '-Syu']
               ),
    opensuse=Image('opensuse/tumbleweed',
                   run_commands=['zypper up'],
                   package_manager='zypper',
                   package_manager_argv=['--non-interactive install']),
    ubuntu=Image('ubuntu', tag='18.04',
                 run_commands=['apt update', 'apt upgrade --yes'],
                 package_manager='apt',
                 package_manager_argv=['--yes', 'install'],
                 env={'DEBIAN_FRONTEND': 'noninteractive'})
)


for name, image in images.items():
    image_dir = docker_dir / name
    dockerfile = image_dir / 'Dockerfile'
    image_dir.mkdir(exist_ok=True)
    dockerfile.write_text(dockerfile_template.render(image=image, **template_args))
    print('Generated', dockerfile)
