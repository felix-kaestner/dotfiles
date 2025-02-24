function g --wraps git --description 'alias g=git'
    if test (count $argv) -eq 0
        command nvim -c ":0Git"
    else
        command git $argv
    end
end
