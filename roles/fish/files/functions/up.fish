function up --description 'Update all system packages'
    if type -q brew
        brew update
        brew upgrade
    end

    if type -q nvim
        nvim --headless "+Lazy! sync" +qa
        nvim --headless "+MasonUpdate" +qa
    end

    if type -q pnpm
        pnpm self-update
    end

    if type -q rustup
        rustup self update
    end

    if type -q uv
        uv self update
    end

    if type -q kubectl; and kubectl krew &>/dev/null
        kubectl krew update
        kubectl krew upgrade
    end

    if type -q u8s
        u8s sync
        u8s update
    end
end
