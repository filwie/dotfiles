#!/usr/bin/env python3
from collections import namedtuple
import sys
from pathlib import Path

try:
    import jinja2
except ImportError:
    print('Cannot import `jinja2`. Install it first.', file=sys.stderr)
    sys.exit(1)


dockerfile_template_file = Path(__file__).parent / 'Dockerfile.j2'
dockerfile_template = jinja2.Template(dockerfile_template_file.read_text())

Image = namedtuple('Image', ['base', 'tag', 'env', 'run_commands',
                             'package_manager', 'package_manager_argv', 'entrypoint'],
                   defaults=['latest', {}, [], '', [], 'fish'])

template_args = {
    'install_packages': ['fish', 'neovim', 'git'],
    'install_sh_argv': ['fish'],
}

images = dict(
    arch=Image('archlinux/base',
               package_manager='pacman',
               package_manager_argv=['--noninteractive', '-Syu']
               ),
    opensuse=Image('opensuse/tumbleweed',
                   package_manager='zypper',
                   package_manager_argv=['--non-interactive']),
    ubuntu=Image('ubuntu', tag='18.04',
                 run_commands=['apt update'],
                 package_manager='apt',
                 package_manager_argv=['--yes'],
                 env={'DEBIAN_FRONTEND': 'noninteractive'})
)


for name, image in images.items():
    print(name, '----------------')
    print(dockerfile_template.render(image=image, **template_args))
