function fd --wraps fd --description 'Find entries in the filesystem'
    command fd --hidden --follow $argv
end
