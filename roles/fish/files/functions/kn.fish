function kn --description 'alias kn=kubens - switch between kubernetes namespaces'
    command kubectl ns $argv
end
