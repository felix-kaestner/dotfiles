function v --wraps nvim --description 'alias v=nvim'
    if test (count $argv) -eq 0; and test -f Session.vim
        command nvim -S Session.vim
    else
        command nvim $argv
    end
end
