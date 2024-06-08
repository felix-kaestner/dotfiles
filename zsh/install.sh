#!/usr/bin/env bash

case $(uname -s) in
'Linux')
    [ -x "$(command -v apt)" ] && sudo apt install -y zsh
    [ -x "$(command -v dnf)" ] && sudo dnf install -y zsh
    ;;
'Darwin')
    brew install zsh zsh-completions zsh-syntax-highlighting zsh-autosuggestions
    ;;
*) ;;
esac
