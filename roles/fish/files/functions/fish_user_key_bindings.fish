function fish_user_key_bindings
    # https://fishshell.com/docs/current/interactive.html#vi-mode-commands
    fish_default_key_bindings -M insert
    fish_vi_key_bindings --no-erase insert

    # https://fishshell.com/docs/current/interactive.html#autosuggestions
    bind -M default \ck accept-autosuggestion
    bind -M insert \ck accept-autosuggestion

    # TMUX session utility
    bind -M default \cf '~/.local/bin/tmux-sessionizer'
    bind -M insert \cf '~/.local/bin/tmux-sessionizer'

    # https://github.com/junegunn/fzf#setting-up-shell-integration
    fzf --fish | source
end
