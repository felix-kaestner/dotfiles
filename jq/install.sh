#!/usr/bin/env bash

case $(uname -s) in
'Linux')
	[ -x "$(command -v apt)" ] && sudo apt install -y jq
	[ -x "$(command -v dnf)" ] && sudo dnf install -y jq
	;;
'Darwin')
	brew install jq
	;;
*) ;;
esac
