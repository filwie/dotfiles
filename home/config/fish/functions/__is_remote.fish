function _is_remote -d "Check if connected via SSH"
    set -q REMOTE_SESSION || set -q SSH_TTY || set -q SSH_CLIENT
end
