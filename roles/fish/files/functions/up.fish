function up --description 'Update all system packages'
    if type -q brew
        brew update
        brew upgrade
    end

    if type -q nvim
        nvim --headless "+Lazy! sync" +qa
        nvim --headless "+MasonUpdate" +qa
    end
end
