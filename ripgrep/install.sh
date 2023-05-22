#!/usr/bin/env bash

case $(uname -s) in
'Linux')
	[ -x "$(command -v apt)" ] && sudo apt install -y ripgrep
	[ -x "$(command -v dnf)" ] && sudo dnf install -y ripgrep
	;;
'Darwin')
	brew install ripgrep
	;;
*) ;;
esac
