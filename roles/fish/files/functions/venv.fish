function venv --description 'Source a virtualenv'
    set -l dir (fd -d 1 -t d --base-directory ~/.venvs --path-separator "" | fzf --height ~100% --header 'Select a virtualenv to activate in the current shell')
    if test -n $dir; and test -d "$HOME/.venvs/$dir"
        source "$HOME/.venvs/$dir/bin/activate.fish"
    end
end
