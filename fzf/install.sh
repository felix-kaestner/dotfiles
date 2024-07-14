#!/usr/bin/env bash

case $(uname -s) in
'Linux')
    [ -x "$(command -v apt)" ] && sudo apt install -y fzf
    [ -x "$(command -v dnf)" ] && sudo dnf install -y fzf
    ;;
'Darwin')
    brew install fzf
    ;;
*) ;;
esac

mkdir -p $HOME/.fzf
curl -fsSL -o $HOME/.fzf/fzf-git.sh https://raw.githubusercontent.com/junegunn/fzf-git.sh/main/fzf-git.sh
