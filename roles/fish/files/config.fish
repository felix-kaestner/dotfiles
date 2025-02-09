set -gx LANG en_US.UTF-8

set -gx EDITOR "nvim"
set -gx GPG_TTY (tty)

# set XDG base directories
set -q XDG_CONFIG_HOME; or set -gx XDG_CONFIG_HOME "$HOME/.config"
set -g XDG_CACHE_HOME; or set -gx XDG_CACHE_HOME "$HOME/.cache"
set -q XDG_DATA_HOME; or set -gx XDG_DATA_HOME "$HOME/.local/share"
set -q XDG_BIN_HOME; or set -gx XDG_BIN_HOME "$HOME/.local/bin"

set -gx RIPGREP_CONFIG_PATH "$XDG_CONFIG_HOME/ripgrep/ripgreprc"

if type -q nerdctl
    set -gx KIND_EXPERIMENTAL_PROVIDER nerdctl
end

# include brew shellenv
if test -x "/opt/homebrew/bin/brew"
    /opt/homebrew/bin/brew shellenv | source
end

# set PATH so it includes user's private bin if it exists
fish_add_path "$HOME/.local/bin"

# set PATH so it includes pnpm home if it exists
set -gx PNPM_HOME "$HOME/.local/share/pnpm"
fish_add_path "$PNPM_HOME"

# set PATH so it includes golang's user bin if it exists
set -gx GOPATH "$HOME/.go"
fish_add_path "$GOPATH/bin"

# set PATH so it includes user's ruby bin directory if it exists
set -gx GEM_HOME "$HOME/.gem"
fish_add_path "$GEM_HOME/bin"

# set PATH so it includes user's krew bin directory if it exists
fish_add_path "$HOME/.krew/bin"

# set PATH so it includes user's cargo bin if it exists
fish_add_path "$HOME/.cargo/bin"

# set PATH so it includes user's symfony bin directory if it exists
fish_add_path "$HOME/.symfony/bin"

# set PATH so it includes user's flutter bin directory if it exists
fish_add_path "$HOME/.flutter/bin"

test -f "$XDG_CONFIG_HOME/fish/local.fish"; and source "$XDG_CONFIG_HOME/fish/local.fish"

if status is-interactive
    # https://fishshell.com/docs/current/interactive.html#configurable-greeting
    set -g fish_greeting

    # https://fishshell.com/docs/current/interactive.html#vi-mode-commands
    set -g fish_key_bindings fish_hybrid_key_bindings

    # vi cursor behavior
    set -g fish_cursor_insert line
    set -g fish_cursor_visual block
    set -g fish_cursor_default block
    set -g fish_cursor_replace underscore
    set -g fish_cursor_replace_one underscore
    set -g fish_cursor_external line
    set -g fish_vi_force_cursor 1

    # https://fishshell.com/docs/current/interactive.html#autosuggestions
    bind -M default \ck accept-autosuggestion
    bind -M insert \ck accept-autosuggestion

    # TMUX session utility
    bind -M default \cf '~/.local/bin/tmuxs'
    bind -M insert \cf '~/.local/bin/tmuxs'

    # https://github.com/junegunn/fzf#setting-up-shell-integration
    fzf --fish | source
    set -gx FZF_ALT_C_OPTS "
        --preview 'tree -C {}'"
    set -gx FZF_CTRL_R_OPTS "
        --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
        --header 'Press CTRL-Y to copy command into clipboard'
        --color header:italic"
    set -gx FZF_CTRL_T_OPTS "
        --preview 'cat -n -t {}'
        --bind 'ctrl-e:become($EDITOR {} < /dev/tty > /dev/tty)+abort'
        --header 'Press CTRL-E to open file in $EDITOR'
        --color header:italic"
    set -gx FZF_DEFAULT_OPTS "
        --color=bg:#1e1e2e,bg+:#313244
        --color=fg:#cdd6f4,fg+:#cdd6f4
        --color=hl:#f38ba8,hl+:#eba0ac
        --color=info:#89b4fa,prompt:#89b4fa
        --color=marker:#f2cdcd,header:#a6adc8
        --color=pointer:#f5e0dc,spinner:#f5e0dc
        --color=selected-bg:#45475a"

    abbr --add dotdot --regex '^\.\.+$' --function _dotdot

    # GPG Settings - based on: https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/gpg-agent/gpg-agent.plugin.zsh#L12
    if test (gpgconf --list-options gpg-agent 2>/dev/null | awk -F: '$1=="enable-ssh-support" {print $10}') = 1
        set -e SSH_AGENT_PID
        if test -z $gnupg_SSH_AUTH_SOCK_by; or test $gnupg_SSH_AUTH_SOCK_by -ne $fish_pid
            set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
        end
    end

    gpgconf --launch gpg-agent

    # automatically expose docker host through in lima-vm
    if type -q limactl; and string match -q "Running" (limactl ls -f '{{ .Status }}' docker 2>/dev/null)
        set -gx DOCKER_HOST (limactl list docker --format 'unix://{{.Dir}}/sock/docker.sock')
        set -gx TESTCONTAINERS_HOST_OVERRIDE (limactl shell docker ip a show lima0 | awk '/inet / {sub("/.*",""); print $2}')
        set -gx TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE /var/run/docker.sock
    end

    set -gx --path KUBECONFIG "$HOME/.kube/config"
    if type -q limactl; and string match -q "Running" (limactl ls -f '{{ .Status }}' k8s 2>/dev/null)
        set -p KUBECONFIG (limactl list "k8s" --format "{{.Dir}}/copied-from-guest/kubeconfig.yaml")
    end
    if type -q u8s; and test -f "$HOME/.config/SAPCC/u8s/.kube/config"
        set -p KUBECONFIG "$HOME/.config/SAPCC/u8s/.kube/config"
    end
end
