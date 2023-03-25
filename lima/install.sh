#!/usr/bin/env bash

case $(uname -s) in
'Linux')
	if [ -f /usr/local/bin/lima ]; then
		echo "lima is already installed. Skipping..."
	else
		VERSION=$(curl -fsSL https://api.github.com/repos/lima-vm/lima/releases/latest | jq -r .tag_name)
		curl -fsSL "https://github.com/lima-vm/lima/releases/download/${VERSION}/lima-${VERSION:1}-$(uname -s)-$(uname -m).tar.gz" | sudo tar Cxzvm /usr/local
	fi
	;;
'Darwin')
	brew install lima
	;;
*) ;;
esac
