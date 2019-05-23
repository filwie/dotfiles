function syncrepo -a dest
    set -l repo (realpath (git rev-parse --show-toplevel))
    set -l gitignore (realpath (git rev-parse --show-toplevel)/.gitignore)
    echo $repo $gitignore

    rsync -avz $repo --filter=':- '$gitignore $dest
    while command inotifywait -r -e modify,attrib,close_write,move,create,delete $repo
        rsync -avz $repo --filter=':- '$gitignore $dest
    end
end
