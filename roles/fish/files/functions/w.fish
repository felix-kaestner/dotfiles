function w --description 'alias w=watch - execute a program periodically, showing output fullscreen'
    command watch -tx fish -c "$argv"
end
