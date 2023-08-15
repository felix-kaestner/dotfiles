#!/usr/bin/env bash

case $(uname -s) in
'Linux')
	[ -x "$(command -v apt)" ] && sudo apt install -y kitty
	[ -x "$(command -v dnf)" ] && sudo dnf install -y kitty
	;;
'Darwin')
	brew install --cask kitty
	;;
*) ;;
esac

~/.local/bin/theme-switcher mocha

