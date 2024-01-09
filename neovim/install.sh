#!/usr/bin/env bash

case $(uname -s) in
'Linux')
    [ -x "$(command -v apt)" ] && sudo apt install -y neovim
    [ -x "$(command -v dnf)" ] && sudo dnf install -y neovim
    ;;
'Darwin')
    brew install neovim
    ;;
*) ;;
esac
