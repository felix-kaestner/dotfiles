#!/usr/bin/env bash

case $(uname -s) in
'Linux')
	[ -x "$(command -v apt)" ] && sudo apt install -y fd-find
	[ -x "$(command -v dnf)" ] && sudo dnf install -y fd-find
	;;
'Darwin')
	brew install fd
	;;
*) ;;
esac
