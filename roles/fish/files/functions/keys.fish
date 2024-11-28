function keys --description 'List secret gpg keys'
    gpg --list-secret-keys --keyid-format LONG
end
