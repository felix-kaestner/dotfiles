function dr --wraps docker --description 'Launch a container command within the current working directory'
    command docker run --rm -it -w /workspace -v (pwd):/workspace $argv
end
