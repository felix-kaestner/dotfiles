function pass --wraps pass --description 'pass - stores, retrieves, generates, and synchronizes passwords securely'
    EDITOR="nvim --clean" command pass $argv
end
