function __docker_is_container -d 'Detect if host is a Docker container'
    test -f "/.dockerenv"
end
