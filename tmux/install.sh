#!/usr/bin/env bash

case $(uname -s) in
'Linux')
	[ -x "$(command -v apt)" ] && sudo apt install -y tmux
	[ -x "$(command -v dnf)" ] && sudo dnf install -y tmux
	;;
'Darwin')
	brew install tmux
	;;
*) ;;
esac
