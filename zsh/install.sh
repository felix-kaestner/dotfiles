#!/usr/bin/env bash


# zsh is installed by default on macOS since Catalina
case $(uname -s) in
'Linux')
	[ -x "$(command -v apt)" ] && sudo apt install -y zsh
	[ -x "$(command -v dnf)" ] && sudo dnf install -y zsh
    if [ -x "$(command -v chsh)" ]; then
        chsh -s "$(command -v zsh)"
    fi
	;;
*) ;;
esac

