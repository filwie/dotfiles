# Dotfiles
## Quickstart
Installation of all dotfiles or a subset of them can be done using `install.py` script (requires `Python3.6+`).

To list available dotfiles:
```sh
./install.py --list
```

To install dotfiles, execute the script without arguments (installs all available dotfiles)
or pass one or more names from list displayed as a result of above command. If dotfiles
already exist in specified location they will be backed up and then replaced.


## Fish
### Theme
Make sure your terminal emulator handles truecolor and glyphs and
you have installed one of [Nerd Fonts](https://www.nerdfonts.com/)
I use `Iosevka` and that's what can be seen on screenshots below.
As for terminal emulator I've been enjoying [Kitty](https://sw.kovidgoyal.net/kitty/)
even though I don't use most of it's features.

Colorscheme visible on all screenshots is [Gruvbox](https://github.com/morhetz/gruvbox)

Glyphs are not enabled by default - to enable them set environment variable `THEME_ENABLE_GLYPHS` to anything but empty string. I put below line in `kitty.conf`:

``` conf
env THEME_ENABLE_GLYPHS=1
```

Theme relies on following files from this repository:
- `$FISH_DIR/functions/fish_prompt.fish`
- `$FISH_DIR/functions/fish_mode_prompt.fish` (when using Vi mode)
- `$FISH_DIR/conf.d/03-event_handlers.fish` (for setting variables
   holding Python, Go versions, git remote etc.)

Currently implemented theme features:
- [x] distinct prompt for different operating systems:
<img src="https://raw.githubusercontent.com/filwie/images/master/dotfiles/oses.png" align="center" alt="oses"/>

- [x] informative git status along with different glyphs depending on origin URL
<img src="https://raw.githubusercontent.com/filwie/images/master/dotfiles/remotes.png" align="center" alt="remotes"/>

### Try it out in a container
It is possible to check out theme in Docker container. Currently,
dockerfiles for following distributions are available:
- [ ] OpenSUSE Tumbleweed
- [ ] Arch Linux
- [ ] Ubuntu 18.04

To build those images execute below commands from repo root (__requirements:__ `Docker`,
`Python 3`, `Jinja2` `Python` package)
``` sh
cd docker
./build_images.sh
```

By default, the images are tagged `latest` and are named according to `dotfiles-{{ short distro name }}` convention. It can be customized via `IMAGE_TAG`, `IMAGE_PREFIX` and `IMAGE_SUFFIX` environment variables.

To run container and see theme in action simply run:

``` sh
# opensuse, arch or ubuntu
docker run -it --rm dotfiles-opensuse:latest
```

## NeoVim
## Tmux
## Kitty
## i3
## rofi
## VSCode
