function venv --description 'Source a virtualenv'
    set -l dir (fd -d 1 -t d --base-directory ~/.venvs --path-separator "" | fzf --tmux)
    if test -n $dir; and test -d "$HOME/.venvs/$dir"
        source "$HOME/.venvs/$dir/bin/activate.fish"
    end
end
