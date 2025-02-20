function up --description 'Update all system packages'
    if type -q brew
        brew update
        brew upgrade
    end

    if type -q pnpm
        pnpm self-update
    end

    if type -q rustup
        rustup self update
    end

    if type -q uv
        uv self update
        uv tool upgrade --all
    end

    if type -q kubectl; and kubectl krew &>/dev/null
        kubectl krew update
        kubectl krew upgrade
    end

    if type -q u8s
        u8s sync
        u8s update
    end

    for bin in ~/.go/bin/*
        set -l mod (go version -m "$bin" | awk '/path/ {print $2;exit}')
        printf "\e[1;36m=> go install %s@latest\e[0m\n" "$mod"
        go install "$mod@latest"
    end
end
