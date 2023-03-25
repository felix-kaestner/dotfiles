#!/usr/bin/env bash

case $(uname -s) in
'Linux')
	if [ -f /etc/os-release ]; then
		case $(awk -F= '/^ID=/{print $2}' /etc/os-release) in
		'debian' | 'ubuntu')
			curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
			sudo apt install -y nodejs
			sudo npm install -g yarn
			sudo npm install -g pnpm
			;;
		'fedora')
			sudo dnf install -y nodejs
			sudo npm install -g yarn
			sudo npm install -g pnpm
			;;
		*) ;;
		esac
	fi
	;;
'Darwin')
	brew install node yarn pnpm
	;;
*) ;;
esac
