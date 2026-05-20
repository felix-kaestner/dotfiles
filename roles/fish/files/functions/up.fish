function up --description 'Update all system packages'
    if type -q brew
        brew update
        brew upgrade
    end

    if type -q pnpm
        pnpm self-update
        if type -q gh; and gh auth status -h github.com &>/dev/null
            GH_TOKEN=(gh auth token -h github.com) pnpm dlx skills update -g
        else
            pnpm dlx skills update -g
        end
    end

    if type -q rustup
        rustup self update
    end

    if type -q uv
        uv self update
        uv tool upgrade --all
    end

    if type -q cargo; and test -f "$CARGO_HOME/.crates2.json"
        set -l pkgs (cat $CARGO_HOME/.crates2.json | jq -r '.installs | keys[] | split(" ")[0]')
        if test (count $pkgs) -gt 0
            cargo install --locked $pkgs
        end
    end

    if type -q kubectl; and kubectl krew &>/dev/null
        kubectl krew update
        kubectl krew upgrade
    end

    if type -q helm
        helm plugin ls | tail -n +2 | awk '{print $1}' | parallel --will-cite 'helm plugin update {}'
    end

    if type -q u8s
        u8s sync
        u8s update
    end

    if type -q hammer
        hammer update
    end

    for bin in ~/.go/bin/*
        go version -m "$bin" | awk '/path/ {print $2;exit}'
    end | parallel --will-cite 'printf "\e[1;36m=> go install {}@latest\e[0m\n" && go install {}@latest'
end
