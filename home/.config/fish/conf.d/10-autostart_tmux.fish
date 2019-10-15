function _start_or_attach_tmux  -d 'Start new tmux session or attach to existing one'  # {{{
    command -v tmux > /dev/null; or return
    if test -z $TMUX
        set -l session_id (tmux ls | grep -vm1 attached | cut -d: -f1)
        if test -z $session_id
            tmux -2 new-session
        else
            tmux -2 attach-session -t $session_id
        end
    end
end  # }}}

set -q TMUX_ALWAYS; and _start_or_attach_tmux
