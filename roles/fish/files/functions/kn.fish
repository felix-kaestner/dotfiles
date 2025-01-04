function kn --wraps kubectl --description 'alias kn=kubens'
    command kubectl ns $argv
end
