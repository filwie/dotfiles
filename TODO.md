- [ ] [_OPTIONAL_] rewrite script to python
- [ ] detect if remote session in zshrc:
``` sh
if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
    # set some vars (BEFORE starting/ attaching to tmux session)
fi
```
- [ ] detect if running in docker
``` sh
if ! [[ -f "/.dockerenv" ]]; then
    docker_status="%{${indicator_color}%}🐋🐳%{${reset_color}%}"
fi
```
- [ ] detect if script is ran from web or locally
``` python
# or maybe sys.argv[0]?
def is_ran_from_web():
    try:
        assert __file__
    except NameError:
        return True
    return False
```
- [ ] zsh theme different if in container / remote
- [ ] tmux status different if in container / remote
